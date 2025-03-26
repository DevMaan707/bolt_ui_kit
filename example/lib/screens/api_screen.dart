import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final ApiService _apiService =
      ApiService('https://jsonplaceholder.typicode.com');
  bool _isLoading = false;
  List<dynamic> _posts = [];
  Map<String, dynamic>? _selectedPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'API Integration',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Demo',
                    style: AppTextThemes.heading5(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This demo uses JSONPlaceholder API to showcase API integration.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          text: 'GET Posts',
                          type: ButtonType.primary,
                          icon: Icons.download,
                          isLoading: _isLoading,
                          onPressed: _fetchPosts,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Button(
                          text: 'Create Post',
                          type: ButtonType.outlined,
                          icon: Icons.add,
                          onPressed: _createPost,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_posts.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Posts (${_posts.length})',
                  style: AppTextThemes.heading6(),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _posts.length.clamp(0, 10),
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return ListTile(
                    title: Text(
                      post['title'] ?? 'No title',
                      style:
                          AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post['body'] ?? 'No content',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _viewPostDetails(post),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                  );
                },
              ),
            ],
            if (_selectedPost != null) ...[
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: AppCard(
                  type: CardType.elevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Post',
                        style: AppTextThemes.heading6(),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _selectedPost!['title'] ?? 'No title',
                        style: AppTextThemes.bodyLarge(
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _selectedPost!['body'] ?? 'No content',
                        style: AppTextThemes.bodyMedium(),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Button(
                              text: 'Update',
                              type: ButtonType.outlined,
                              icon: Icons.edit,
                              onPressed: () =>
                                  _updatePost(_selectedPost!['id']),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Button(
                              text: 'Delete',
                              type: ButtonType.outlined,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              textColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: () =>
                                  _deletePost(_selectedPost!['id']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.get(
        endpoint: '/posts',
      );

      setState(() {
        _posts = response as List<dynamic>;
        _isLoading = false;
      });

      Toast.show(
        message: 'Successfully loaded ${_posts.length} posts',
        type: ToastType.success,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show(
        message: 'Failed to load posts',
        type: ToastType.error,
      );
    }
  }

  Future<void> _createPost() async {
    try {
      final response = await _apiService.post(
        endpoint: '/posts',
        body: {
          'title': 'New Post',
          'body': 'This is a new post created from the Flutter Kit Demo app.',
          'userId': 1,
        },
      );

      Toast.show(
        message: 'Post created with ID: ${response['id']}',
        type: ToastType.success,
      );
      setState(() {
        _posts.insert(0, response);
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to create post',
        type: ToastType.error,
      );
    }
  }

  Future<void> _updatePost(int id) async {
    try {
      final response = await _apiService.put(
        endpoint: '/posts/$id',
        body: {
          'id': id,
          'title': 'Updated Post',
          'body':
              'This post has been updated using the Flutter Kit API service.',
          'userId': 1,
        },
      );

      Toast.show(
        message: 'Post updated successfully',
        type: ToastType.success,
      );
      setState(() {
        _selectedPost = response;
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to update post',
        type: ToastType.error,
      );
    }
  }

  Future<void> _deletePost(int id) async {
    try {
      await _apiService.delete(
        endpoint: '/posts/$id',
      );

      Toast.show(
        message: 'Post deleted successfully',
        type: ToastType.success,
      );
      setState(() {
        _posts.removeWhere((post) => post['id'] == id);
        _selectedPost = null;
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to delete post',
        type: ToastType.error,
      );
    }
  }

  void _viewPostDetails(Map<String, dynamic> post) {
    setState(() {
      _selectedPost = post;
    });
  }
}

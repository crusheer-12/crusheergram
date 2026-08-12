class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final int likesCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    this.likesCount = 0,
  });

  factory PostModel.fromMap(String id, Map<String, dynamic> data) {
    return PostModel(
      id: id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userImage: data['userImage'] ?? '',
      postImage: data['postImage'] ?? '',
      caption: data['caption'] ?? '',
      likesCount: data['likesCount'] ?? 0,
    );
  }
}

class ImageModel {
  final String previewURL;
  final String largeImageURL;
  final int likes;
  final int views;

  ImageModel({
    required this.previewURL,
    required this.largeImageURL,
    required this.likes,
    required this.views,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      previewURL: json['previewURL'],
      largeImageURL: json['largeImageURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}

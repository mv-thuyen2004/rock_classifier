class NewsModels {
  final String? uid;
  final String? title;
  final String? content;
  final String? image;
  final String? link;
  NewsModels({
    this.uid,
    this.title,
    this.content,
    this.image,
    this.link,
  });

  factory NewsModels.fromJson(Map<String, dynamic> json) {
    return NewsModels(
      uid: json['uid'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'content': content,
      'image': image,
      'link': link,
    };
  }

  NewsModels copyWith({
    String? uid,
    String? title,
    String? content,
    String? image,
    String? link,
  }) {
    return NewsModels(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      link: link ?? this.link,
    );
  }
}

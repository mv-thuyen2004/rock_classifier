import 'package:flutter/material.dart';
import 'package:nckh/views/home/post_screen.dart';

class ArticleSection extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {"title": "Sự hình thành của đá?", "image": "assets/baiviet1.jpg"},
    {
      "title": "10 loại đá quý hiếm trên thế giới gồm những gì?",
      "image": "assets/baiviet2.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Những bài viết về đá",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Màu chữ đậm hơn
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: articles.map((article) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6), // Tạo khoảng cách giữa 2 card
                  child: ArticleCard(
                    title: article["title"]!,
                    imagePath: article["image"]!,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatefulWidget {
  final String title;
  final String imagePath;

  const ArticleCard({required this.title, required this.imagePath});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _controller.addListener(() {
      setState(() {
        _scale = 1 - _controller.value;
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    _navigateToDetail();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _navigateToDetail() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => PostScreen(
        title: widget.title,
        imagePath: widget.imagePath,
      ),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

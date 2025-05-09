import 'package:flutter/material.dart';

class RockImageDialog extends StatelessWidget {
  final String imagePath;

  const RockImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // Chạm nền để thoát
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.98),
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close, color: Colors.white, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

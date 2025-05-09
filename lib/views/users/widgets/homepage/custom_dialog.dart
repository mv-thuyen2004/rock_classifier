import 'package:flutter/material.dart';

void showRockAlertDialog(BuildContext context, String title, String message) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Dialog",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, _, __) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, _, __) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: _RockDialogContent(title: title, message: message),
          ),
        ),
      );
    },
  );
}

class _RockDialogContent extends StatelessWidget {
  final String title;
  final String message;

  const _RockDialogContent({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E4C59), Color(0xFF263238)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon đá
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7C9473), Color(0xFF546E7A)],
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: const Icon(
              Icons.landscape_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Tiêu đề
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Nội dung
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),

          // Nút
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7C873),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
            ),
            child: const Text(
              "Thử lại",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

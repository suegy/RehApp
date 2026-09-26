import 'package:flutter/material.dart';

abstract final class AppColors {
  static const plum = Color(0xFF403757);
  static const violet = Color(0xFF8973B8);
  static const lilac = Color(0xFFEEE8FA);
  static const peach = Color(0xFFFFD9CC);
  static const butter = Color(0xFFFFF0AE);
  static const mint = Color(0xFFD7F0DF);
  static const sky = Color(0xFFD8EDFA);
  static const paper = Color(0xFFFFFAF5);
}

abstract final class AppTheme {
  static ThemeData build() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.violet,
        brightness: Brightness.light,
        surface: AppColors.paper,
      ),
      // System fonts are reliable on web, Android, and iOS. An embedded
      // accessibility font can replace this stack once its license is chosen.
      fontFamily: 'Arial',
      scaffoldBackgroundColor: AppColors.paper,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: .94),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(11),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(14),
          ),
          borderSide: const BorderSide(color: Color(0xFFDFD5EE), width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.violet,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(44),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
      ),
      useMaterial3: true,
    );
  }
}

class MaterialTexture extends StatelessWidget {
  const MaterialTexture({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TexturePainter(color),
      child: const SizedBox.expand(),
    );
  }
}

class _TexturePainter extends CustomPainter {
  const _TexturePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    canvas.drawCircle(
      Offset(size.width * .85, size.height * .13),
      size.width * .32,
      Paint()..color = Colors.white.withValues(alpha: .10),
    );
    final grain = Paint()
      ..color = AppColors.violet.withValues(alpha: .025)
      ..strokeWidth = 1;
    for (var x = -size.height; x < size.width; x += 14) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        grain,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TexturePainter oldDelegate) =>
      oldDelegate.color != color;
}

import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class LocaleToggle extends StatelessWidget {
  const LocaleToggle({
    super.key,
    required this.locale,
    required this.onChanged,
    this.light = false,
  });

  final String locale;
  final ValueChanged<String> onChanged;
  final bool light;

  @override
  Widget build(BuildContext context) => SegmentedButton<String>(
    showSelectedIcon: false,
    style: ButtonStyle(
      visualDensity: VisualDensity.compact,
      foregroundColor: WidgetStatePropertyAll(
        light ? Colors.white : AppColors.plum,
      ),
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStatePropertyAll(
        BorderSide(color: light ? Colors.white70 : AppColors.violet),
      ),
    ),
    segments: const [
      ButtonSegment(value: 'sv', label: Text('sv')),
      ButtonSegment(value: 'en', label: Text('en')),
    ],
    selected: {locale},
    onSelectionChanged: (selection) => onChanged(selection.first),
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.large = false, this.light = false});

  final bool large;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : AppColors.plum;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 31 : 25,
          height: large ? 36 : 29,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.butter, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'KI Support',
              style: TextStyle(
                color: color,
                fontSize: large ? 28 : 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!large)
              Text(
                'DIN EGEN VAG FRAMAT',
                style: TextStyle(
                  color: color.withValues(alpha: .8),
                  fontSize: 8,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class SoftPanel extends StatelessWidget {
  const SoftPanel({
    super.key,
    required this.child,
    this.accent = AppColors.peach,
  });

  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      border: const Border(
        top: BorderSide(color: AppColors.lilac, width: 3),
        right: BorderSide(color: AppColors.lilac),
        bottom: BorderSide(color: AppColors.lilac, width: 4),
        left: BorderSide(color: AppColors.lilac, width: 2),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(27),
        topRight: Radius.circular(19),
        bottomLeft: Radius.circular(31),
        bottomRight: Radius.circular(18),
      ),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: .85),
          offset: const Offset(4, 6),
        ),
        BoxShadow(
          color: AppColors.plum.withValues(alpha: .08),
          blurRadius: 14,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: child,
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, this.small = false});
  final String label;
  final bool small;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: small ? 6 : 9,
      vertical: small ? 2 : 4,
    ),
    decoration: BoxDecoration(
      color: AppColors.mint,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: small ? 9 : 11, fontWeight: FontWeight.bold),
    ),
  );
}

class NumberBadge extends StatelessWidget {
  const NumberBadge({super.key, required this.number, this.small = false});
  final String number;
  final bool small;
  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 38.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.violet,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.paper, width: 3),
      ),
      child: Text(
        number,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

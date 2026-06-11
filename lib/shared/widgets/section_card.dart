import 'package:flutter/material.dart';

import '../../app/theme/calc_colors.dart';

/// Standard content card used across converter / finance / settings.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: calc.accentSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 18, color: calc.accent),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

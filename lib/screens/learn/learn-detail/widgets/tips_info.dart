import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

class TipsInfo extends StatelessWidget {
  const TipsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.highlightContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: AppColors.highlight),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnHighlight,
                ),
                children: [
                  TextSpan(
                    text: "Tip: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.highlight,
                    ),
                  ),
                  const TextSpan(
                    text:
                        "Speak clearly. Wait until soundwaves appears to start speaking.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

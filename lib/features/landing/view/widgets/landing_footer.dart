import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/shared/widgets/theme_toggle_button.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: palette.footerBg,
        border: Border(top: BorderSide(color: palette.borderSubtle, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Rhapsody Media Network',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Broadcasting the message of faith and hope to the world.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              const Text('About', style: TextStyle(color: Colors.white54)),
              const Text('Programs', style: TextStyle(color: Colors.white54)),
              const Text('Contact', style: TextStyle(color: Colors.white54)),
              const Text('Privacy Policy', style: TextStyle(color: Colors.white54)),
              ThemeToggleButton(iconColor: Colors.white70),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withValues(alpha: 0.12), thickness: 0.5),
          const SizedBox(height: 12),
          const Text(
            '© 2026 Rhapsody Media Network. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

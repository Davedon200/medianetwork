import 'package:flutter/material.dart';
import 'package:rhapsody_media_network/widgets/widget.dart';

class AnimatedFooter extends StatefulWidget {
  const AnimatedFooter({super.key});

  @override
  State<AnimatedFooter> createState() => _AnimatedFooterState();
}

class _AnimatedFooterState extends State<AnimatedFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: _buildFooter(context)),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F1A),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return Column(
            children: [
              isMobile
                  ? Column(
                      children: [
                        _brandSection(),
                        const SizedBox(height: 24),
                        _linkSection(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _brandSection()),
                        Expanded(child: _linkSection()),
                      ],
                    ),

              const SizedBox(height: 32),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),

              isMobile
                  ? Column(
                      children: [
                        _copyright(),
                        const SizedBox(height: 10),
                        _socials(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_copyright(), _socials()],
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _brandSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rhapsody Media Network",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Broadcasting faith, hope, and transformation to a global audience through impactful media.",
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget _copyright() {
    return const Text(
      "© 2026 Rhapsody Media Network. All rights reserved.",
      style: TextStyle(color: Colors.white38, fontSize: 12),
    );
  }

  Widget _link(String text) {
    return HoverScale(
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
      ),
    );
  }

  Widget _linkSection() {
    final links = ["About", "Live TV", "On Demand", "Testimonies", "Contact"];

    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: links.map(_link).toList(),
    );
  }

  Widget _socials() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        HoverIcon(icon: Icons.facebook),
        SizedBox(width: 16),
        HoverIcon(icon: Icons.play_circle_fill),
        SizedBox(width: 16),
        HoverIcon(icon: Icons.alternate_email),
      ],
    );
  }
}

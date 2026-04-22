import 'package:flutter/material.dart';
import 'package:rhapsody_media_network/routes.dart';
import 'package:rhapsody_media_network/widgets/extension.dart';
import 'package:rhapsody_media_network/widgets/textstyles.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(color: Color(0xFF020617)),
      child: isMobile ? _mobileLayout(context) : _webLayout(context),
    );
  }

  /// ================= MOBILE VIEW =================
  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP BAR (LOGO + NAME + MENU ICON)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/rnm.png",
              fit: BoxFit.scaleDown,
              height: 40,
              width: 40,
            ),

            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                "Rhapsody Media Network",
                style: WebTextStyles.heading.copyWith(
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
            ),

            /// MENU DROPDOWN
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              color: const Color(0xFF020617),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    context.pushNamedAndRemoveUntil(WebRoutes.explorepage);
                  },
                  value: "Home",
                  child: Text("Home", style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  onTap: () {
                    context.pushNamed(WebRoutes.resource);
                  },
                  value: "Resources",
                  child: Text(
                    "Resources",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: "Creators",
                  child: Text(
                    "Creators",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: "Projects",
                  child: Text(
                    "Projects",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: "Analytics",
                  child: Text(
                    "Analytics",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// ================= WEB / FOLD VIEW =================
  Widget _webLayout(BuildContext context) {
    return Row(
      children: [
        /// LOGO + NAME
        Row(
          children: [
            Image.asset(
              "assets/images/rnm.png",
              fit: BoxFit.scaleDown,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                "Rhapsody Media Network",
                style: WebTextStyles.heading.copyWith(
                  fontSize: 19,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),

        const Spacer(),

        /// NAV ITEMS (WEB STYLE)
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pushNamedAndRemoveUntil(WebRoutes.explorepage);
              },
              child: NavItem("Home"),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(WebRoutes.resource);
              },
              child: NavItem("Resources"),
            ),
            NavItem("Creators"),
            NavItem("Projects"),
            NavItem("Analytics"),
            SizedBox(width: 20),
            Icon(Icons.search, color: Colors.white70),
            SizedBox(width: 20),
            CircleAvatar(radius: 14),
          ],
        ),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  const NavItem(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(title, style: const TextStyle(color: Colors.white70)),
    );
  }
}

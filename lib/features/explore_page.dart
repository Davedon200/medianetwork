import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_network/model/web_models.dart';
import 'package:media_network/routes.dart';
import 'package:media_network/widgets/extension.dart';
import 'package:media_network/widgets/textstyles.dart';
import 'package:media_network/widgets/widget.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MediaItem> items = [
      MediaItem(
        title: "Sample Video",
        url:
            "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
        thumbnail:
            "https://peach.blender.org/wp-content/uploads/title_anouncement.jpg",
        type: "video",
      ),
      MediaItem(
        title: "Sample Image",
        url: "https://picsum.photos/800",
        thumbnail: "https://picsum.photos/300",
        type: "image",
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color.fromARGB(255, 31, 47, 85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Column(
            children: [
              const TopNavBar(),

              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          /// HERO / ABOUT SECTION
                          const HeroSection(),

                          const SizedBox(height: 40),

                          /// RESOURCE SECTION TITLE
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Resource Library",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          /// GRID VIEW (RESPONSIVE)
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('media')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final items = snapshot.data!.docs;

                              final width = MediaQuery.of(context).size.width;

                              /// RESPONSIVE BREAKPOINTS
                              int crossAxisCount;
                              double childAspectRatio;

                              if (width < 600) {
                                crossAxisCount = 1;
                                childAspectRatio = 1.2; // 🔥 shorter cards
                              } else if (width < 900) {
                                crossAxisCount = 3;
                                childAspectRatio = 0.9;
                              } else {
                                crossAxisCount = 4;
                                childAspectRatio = 0.9;
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final data = Map<String, dynamic>.from(
                                    items[index].data(),
                                  );

                                  return MediaCard(
                                    item: MediaItem(
                                      title: data['title'],
                                      url: data['url'],
                                      thumbnail: data['thumbnail'],
                                      type: data['type'],
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // GridView.builder(
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   padding: const EdgeInsets.all(16),
                          //   gridDelegate:
                          //       const SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 4, // web layout
                          //         mainAxisSpacing: 20,
                          //         crossAxisSpacing: 20,
                          //         childAspectRatio: 0.9,
                          //       ),
                          //   itemCount: items.length,
                          //   itemBuilder: (context, index) {
                          //     return MediaCard(item: items[index]);
                          //   },
                          // ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopNavBar extends StatelessWidget {
  const TopNavBar();

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
          children: [
            Image.asset(
              "assets/images/rnm.png",
              fit: BoxFit.scaleDown,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
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
                    context.pushNamedAndRemoveUntil(WebRoutes.home);
                  },
                  value: "Home",
                  child: Text("Home", style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
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
              shaderCallback: (bounds) =>
                  const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
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
          children: const [
            NavItem("Home"),
            NavItem("Resources"),
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
  const NavItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(title, style: const TextStyle(color: Colors.white70)),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xFF020617),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: isMobile ? _mobileLayout(context) : _webLayout(context),
    );
  }

  /// ================= MOBILE VIEW =================
  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LIVE BADGE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2DD4BF).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF2DD4BF).withValues(alpha: 0.4),
            ),
          ),
          child: const Text(
            "● Global Network Active",
            style: TextStyle(
              color: Color(0xFF2DD4BF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 51),

        /// VISUAL CENTERED
        Center(child: _heroVisual()),
        const SizedBox(height: 36),

        /// HEADLINE (smaller for mobile only)
        const Text(
          "A Global Media Network for Creators",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        /// SUBTEXT
        const Text(
          "Connect, collaborate, and distribute creative content across a living ecosystem of media professionals, studios, and independent creators worldwide.",
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
        ),

        const SizedBox(height: 28),

        /// STATS (wrap for small screens)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _HeroStat(title: "Creators", value: "100+"),
            _HeroStat(title: "Assets", value: "300+"),
            _HeroStat(title: "Countries", value: "124"),
            _HeroStat(title: "Live Projects", value: "100+"),
          ],
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  /// ================= WEB / FOLD VIEW =================
  Widget _webLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2DD4BF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  "● Global Network Active",
                  style: TextStyle(
                    color: Color(0xFF2DD4BF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "A Global Media Network for Creators",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Connect, collaborate, and distribute creative content across a living ecosystem of media professionals, studios, and independent creators worldwide.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: const [
                  _HeroStat(title: "Creators", value: "100+"),
                  SizedBox(width: 24),
                  _HeroStat(title: "Assets", value: "300+"),
                  SizedBox(width: 24),
                  _HeroStat(title: "Countries", value: "124"),
                  SizedBox(width: 24),
                  _HeroStat(title: "Live Projects", value: "100+"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6A5AE0).withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A5AE0).withValues(alpha: 0.25),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2DD4BF).withValues(alpha: 0.10),
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              size: 100,
              color: Colors.white70,
            ),
          ],
        ),
      ],
    );
  }

  /// ================= SHARED VISUAL =================
  Widget _heroVisual() {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// 🔵 GLOW BACKDROP
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6A5AE0).withValues(alpha: 0.15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A5AE0).withValues(alpha: 0.25),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),

        /// 🟢 INNER LAYER
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2DD4BF).withValues(alpha: 0.10),
          ),
        ),

        /// ▶️ ICON
        const Icon(Icons.play_circle_fill, size: 100, color: Colors.white70),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String title;
  final String value;

  const _HeroStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

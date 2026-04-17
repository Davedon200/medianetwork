import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_network/model/web_models.dart';
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

                          /// GRID VIEW (WEB STYLE)
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

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 0.9,
                                    ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final data = Map<String, dynamic>.from(
                                    items[index].data(),
                                  );

                                  return MediaCard(
                                    item: MediaItem(
                                      // id: items[index].id,
                                      title: data['title'],
                                      url: data['url'],
                                      thumbnail: data['thumbnail'],
                                      type: data['type'],
                                      // downloads: data['downloads'] ?? 0,
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
      child: Row(
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
              SizedBox(width: 10),
              Text(
                "Rhapsody Media Network",
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: WebTextStyles.heading.copyWith(
                  fontSize: isMobile ? 12 : 20,
                  height: 1.1,
                  color: Colors.white,
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
      ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Color(0xFF020617),
        // gradient: LinearGradient(
        //   colors: [
        //     const Color(0xFF0F172A).withValues(alpha: 0.95),
        //     const Color(0xFF1E293B).withValues(alpha: 0.85),
        //   ],
        // ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LIVE BADGE
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

                /// HEADLINE
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

                /// SUBTEXT
                const Text(
                  "Connect, collaborate, and distribute creative content across a living ecosystem of media professionals, studios, and independent creators worldwide.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                /// 📊 MINI DASHBOARD STATS
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

          /// RIGHT VISUAL (PLAY ICON)
          Stack(
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
              const Icon(
                Icons.play_circle_fill,
                size: 100,
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
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

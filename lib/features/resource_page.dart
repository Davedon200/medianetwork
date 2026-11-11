import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rhapsody_media_network/features/widget/top_nav.dart';
import 'package:rhapsody_media_network/model/web_models.dart';
import 'package:rhapsody_media_network/widgets/widget.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({super.key});

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
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

                              final bool isMobile = width < 600;
                              final bool isTablet = width >= 600 && width < 900;

                              /// 📱 MOBILE → LISTVIEW
                              if (isMobile) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(16),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final data = Map<String, dynamic>.from(
                                      items[index].data(),
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: SizedBox(
                                        height: 320,
                                        child: MediaCard(
                                          item: MediaItem(
                                            title: data['title'],
                                            url: data['url'],
                                            thumbnail: data['thumbnail'],
                                            type: data['type'],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              /// 📟 TABLET + DESKTOP → GRIDVIEW
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isTablet ? 3 : 4,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: isTablet ? 0.8 : 0.9,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhapsody_media_network/features/widget/top_nav.dart';
import 'package:rhapsody_media_network/gen/assets.gen.dart';
import 'package:rhapsody_media_network/widgets/constant.dart';
import 'package:rhapsody_media_network/widgets/textstyles.dart';
import 'package:rhapsody_media_network/widgets/widget.dart';
import 'package:video_player/video_player.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF020617),
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🌐 Main Content
          SingleChildScrollView(
            child: Column(
              children: const [
                TopNavBar(),
                HeroSection(),
                FeaturedMediaSection(),
                TrendingSection(),
                ShortFilmsSection(),
                MinistriesSection(),
                NewsSection(),
                GlobalImpactSection(),
                CTASection(),
                FooterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionWrapper({required String title, required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        child,
      ],
    ),
  );
}

Widget _glassContainer({required Widget child}) {
  return Container(
    margin: const EdgeInsets.all(40),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.deepPurple),
    ),
    child: child,
  );
}

class ShortFilmsSection extends StatelessWidget {
  const ShortFilmsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _sectionWrapper(
      title: "Short Films & Originals",
      child: SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, index) {
            return Container(
              width: 420,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(Assets.images.mediaBoostChallenge.path),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "The Calling",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(Assets.videos.boostVideo)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 800;

    return ClipRRect(
      child: SizedBox(
        height: isMobile ? 240 : 400,
        width: double.infinity,
        child: Stack(
          children: [
            // 🖼️ FAST FALLBACK IMAGE (shows instantly)
            Positioned.fill(
              child: Image.asset(
                Assets.images.mediaBoostChallenge.path,
                fit: BoxFit.cover,
              ),
            ),

            // 🎥 VIDEO (fades in when ready)
            if (_controller.value.isInitialized)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),

            // 🔻 SUBTLE BOTTOM FADE ONLY (keep cinematic feel)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xFF020617)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),

            // ✨ CONTENT (WITH LOCAL OVERLAY)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 60,
                vertical: isMobile ? 20 : 40,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Stack(
                    children: [
                      // ✨ ACTUAL CONTENT
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔴 Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "LIVE EVENT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 🎬 Headline (with shadow instead of box)
                            Text(
                              "Rhapsody Media Boost Challenge",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 26 : 44,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(0.8),
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 📝 Description
                            Text(
                              "Stop scrolling. Start winning. Show your creativity and win big.",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isMobile ? 14 : 16,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🎯 Buttons
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                WebButton(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  textColor: Colors.black,
                                  bodytext: "Join the Challenge",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveTVSection extends StatelessWidget {
  const LiveTVSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LIVE TV",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),

          const SizedBox(height: 20),

          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Video Player",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.circle, color: Colors.red, size: 10),
              SizedBox(width: 6),
              Text("LIVE NOW", style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ],
      ),
    );
  }
}

class FeaturedMediaSection extends StatelessWidget {
  const FeaturedMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _sectionWrapper(
      title: "Featured",
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (_, i) => _mediaCard(),
        ),
      ),
    );
  }

  Widget _sectionWrapper({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _mediaCard() {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[900],
      ),
    );
  }
}

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _sectionWrapper(
      title: "Trending",
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 16 / 9,
        ),
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class GlobalImpactSection extends StatelessWidget {
  const GlobalImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _glassContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _counter("150+", "Countries"),
          _counter("2M+", "Viewers"),
          _counter("24/7", "Broadcast"),
        ],
      ),
    );
  }
}

class _counter extends StatelessWidget {
  final String value;
  final String label;

  const _counter(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isMobile ? 18 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.black.withOpacity(0.6))),
      ],
    );
  }
}

class MinistriesSection extends StatelessWidget {
  const MinistriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _sectionWrapper(
      title: "Ministries",
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.public, color: Colors.white, size: 30),
                const SizedBox(height: 20),
                const Text(
                  "Global Outreach",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Reaching nations with the gospel through media.",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const Spacer(),
                const Text(
                  "Learn More →",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 1000
        ? 3
        : width > 600
        ? 2
        : 1;

    return _sectionWrapper(
      title: "News & Updates",
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load news",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          // 📭 Empty
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No news available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
       
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8, // 👈 gives more vertical room
            ),
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? '';
              final imageUrl = data['url'] ?? '';

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼 IMAGE (FULLY VISIBLE)
                      imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.contain, // 🔥 key
                              width: double.infinity,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.images.mediaBoostChallenge.path,
                                  fit: BoxFit.contain,
                                );
                              },
                            )
                          : Image.asset(
                              Assets.images.mediaBoostChallenge.path,
                              fit: BoxFit.contain,
                            ),

                      // 📝 TITLE
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) _brand() else if (isTablet) _brand(),
          const SizedBox(height: 16),

          // 🔻 MAIN CONTENT
          if (isMobile)
            _mobileGridLayout()
          else if (isTablet)
            _tabletLayout()
          else
            _desktopLayout(),

          const SizedBox(height: 30),

          Center(
            child: const Text(
              "© 2026 Rhapsody TV. All rights reserved.",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _brand(),
        _footerColumn("Explore", ["Home", "Live TV", "Programs", "News"]),
        _footerColumn("Ministries", [
          "Outreach",
          "Global Missions",
          "Partners",
        ]),
        _footerColumn("Connect", ["Contact", "Support", "Privacy Policy"]),
      ],
    );
  }

  // ================= TABLET =================
  Widget _tabletLayout() {
    return Wrap(
      spacing: 130,
      runSpacing: 30,
      alignment: WrapAlignment.spaceBetween,
      children: [
        _footerColumn("Explore", ["Home", "Live TV", "Programs", "News"]),
        _footerColumn("Ministries", [
          "Outreach",
          "Global Missions",
          "Partners",
        ]),
        _footerColumn("Connect", ["Contact", "Support", "Privacy Policy"]),
      ],
    );
  }

  // ================= MOBILE (GRID FIX) =================
  Widget _mobileGridLayout() {
    final items = [
      _footerColumn("Explore", ["Home", "Live TV", "Programs", "News"]),
      _footerColumn("Ministries", ["Outreach", "Global Missions", "Partners"]),
      _footerColumn("Connect", ["Contact", "Support", "Privacy Policy"]),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 🔥 KEY FIX
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (_, index) {
        return items[index];
      },
    );
  }

  // ================= BRAND =================
  Widget _brand() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        "Rhapsody Media Network",
        style: WebTextStyles.heading.copyWith(fontSize: 18),
      ),
    );
  }

  // ================= COLUMN =================
  Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(e, style: const TextStyle(color: Colors.black87)),
          ),
        ),
      ],
    );
  }
}

class CTASection extends StatefulWidget {
  const CTASection({super.key});

  @override
  State<CTASection> createState() => _CTASectionState();
}

class _CTASectionState extends State<CTASection> {
  final TextEditingController stayconnectedcontroller = TextEditingController();

  @override
  void dispose() {
    stayconnectedcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stay Connected",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          // 📱 RESPONSIVE LAYOUT
          isMobile
              ? Column(
                  children: [
                    _buildTextField(stayconnectedcontroller, "Enter Email"),
                    const SizedBox(height: 20),
                    WebButton(
                      decoration: boxDecoration,
                      textColor: Colors.white,
                      bodytext: "Subscribe",
                    ),
                  ],
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          stayconnectedcontroller,
                          "Enter Email",
                        ),
                      ),
                      const SizedBox(width: 12),
                      WebButton(
                        decoration: boxDecoration,
                        textColor: Colors.white,
                        bodytext: "Subscribe",
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.deepPurple),

        filled: true,
        fillColor: Colors.deepPurple.withOpacity(0.05),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepPurpleAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

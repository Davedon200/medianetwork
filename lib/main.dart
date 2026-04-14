import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_network/admin/admin_dashboard.dart';
import 'package:media_network/firebase_options.dart';
import 'package:media_network/widgets/constant.dart';
import 'package:media_network/widgets/widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RhapsodyMediaNetworkApp());
}

class RhapsodyMediaNetworkApp extends StatelessWidget {
  const RhapsodyMediaNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhapsody Media Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // ✅ FIX
        ),
        fontFamily: 'Inter',
      ),
      home: RhapsodyLandingPage(),
    );
  }
}

class RhapsodyLandingPage extends StatefulWidget {
  const RhapsodyLandingPage({super.key});

  @override
  State<RhapsodyLandingPage> createState() => _RhapsodyLandingPageState();
}

class _RhapsodyLandingPageState extends State<RhapsodyLandingPage>
    with SingleTickerProviderStateMixin {
  bool showRegisterForm = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController kcController = TextEditingController();
  final TextEditingController ceZoneController = TextEditingController();

  final List<String> selectedSkills = [];

  String? selectedTitle;
  String? selectedNationality;
  String selectedCountryCode = "+234";
  bool isLoading = false;

  // Example list (you can expand later)

  @override
  void initState() {
    super.initState();

    final path = Uri.base.path;

    if (path == '/register') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          showRegisterForm = true;
        });
      });
    }

    _trackVisit();
  }

  Future<void> _trackVisit() async {
    await FirebaseFirestore.instance.collection("analytics").doc("visits").set({
      "count": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        style: const TextStyle(color: Colors.black),

        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),

          filled: true,
          fillColor: const Color.fromARGB(
            255,
            167,
            157,
            157,
          ).withValues(alpha: 0.2),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
              width: 1.5,
            ),
          ),
        ),

        icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),

        dropdownColor: Colors.white,

        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),

        onChanged: onChanged,

        validator: (v) => v == null ? "Please select $label" : null,
      ),
    );
  }

  void _clearForm() {
    setState(() {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      kcController.clear();

      ceZoneController.clear();

      selectedSkills.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0C10), Color(0xFF1F2833)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroSection(isMobile),
                if (!showRegisterForm)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: _buildAboutSection(isMobile),
                  ),

                buildFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Animated Registration Form Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: showRegisterForm ? 0 : MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildRegistrationForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 60 : 80,
      ),
      // decoration: const BoxDecoration(
      //   gradient: RadialGradient(
      //     center: Alignment.topLeft,
      //     radius: 1.2,
      //     colors: [Color(0x332D1B69), Colors.transparent, Colors.black],
      //   ),
      // ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// LEFT CONTENT
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                /// TITLE
                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Text(
                    "Rhapsody Media Network",
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      fontSize: isMobile ? 34 : 58,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// SUBTITLE
                Text(
                  "A global network of creative professionals and media innovators "
                  "dedicated to shaping the future of digital content, storytelling, "
                  "and global media distribution.",
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: isMobile ? 15 : 19,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 18),

                /// VALUE CHIPS
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: isMobile
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: const [
                    HeroChip(label: "Media Production"),
                    HeroChip(label: "Global Network"),
                    HeroChip(label: "Creators Hub"),
                  ],
                ),

                const SizedBox(height: 22),

                /// STATS
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: isMobile
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: [
                    HeroStat(value: "12+", label: "Countries"),
                    HeroStat(value: "50+", label: "Creators"),
                    HeroStat(value: "100+", label: "Reach"),
                  ],
                ),

                const SizedBox(height: 35),

                /// CTA BUTTONS
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: isMobile
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(() => showRegisterForm = true),

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A5AE0), Color(0xFF2DD4BF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(
                                  0.35,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Explore Network",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// SCROLL HINT
                Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    Text(
                      "Scroll to explore",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT IMAGE
          if (!isMobile) ...[
            const SizedBox(width: 30),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=900&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// FLOATING CARD 1
                  Positioned(
                    top: 20,
                    left: 20,
                    child: floatingCard("Live", "Broadcast Active"),
                  ),

                  /// FLOATING CARD 2
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: floatingCard("New", "Creator Joined"),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F1A),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Rhapsody Media Network",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Broadcasting the message of faith and hope to the world.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Links Row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              Text("About", style: TextStyle(color: Colors.white54)),
              Text("Programs", style: TextStyle(color: Colors.white54)),
              Text("Contact", style: TextStyle(color: Colors.white54)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDashboard()),
                  );
                },
                child: Text("Admin", style: TextStyle(color: Colors.white54)),
              ),
              Text("Privacy Policy", style: TextStyle(color: Colors.white54)),
            ],
          ),

          const SizedBox(height: 20),

          const Divider(color: Colors.white12, thickness: 0.5),

          const SizedBox(height: 12),

          const Text(
            "© 2026 Rhapsody Media Network. All rights reserved.",
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF6F7FB),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 50,
        vertical: 100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT CONTENT (TEXT COLUMN)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                // LABEL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "ABOUT RHAPSODY MEDIA NETWORK",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TITLE
                const Text(
                  "A Global Creative Engine\nPowering Rhapsody of Realities",
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 18),

                // DESCRIPTION
                const Text(
                  "Rhapsody Media Network is the official creative ecosystem responsible for designing, producing, and distributing Rhapsody of Realities across digital platforms worldwide. "
                  "We unify creatives, designers, video editors, writers, and media professionals into one structured global system focused on excellence, consistency, and impact.",
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.7,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 80),

                // CARDS
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    _appleCard(
                      icon: Icons.public,
                      title: "Global Distribution",
                      desc: "Delivering content across nations.",
                    ),
                    _appleCard(
                      icon: Icons.auto_awesome,
                      title: "Creative Excellence",
                      desc: "High-quality media production.",
                    ),
                    _appleCard(
                      icon: Icons.groups,
                      title: "Unified Network",
                      desc: "Connected global creatives.",
                    ),
                    _appleCard(
                      icon: Icons.rocket_launch,
                      title: "Digital Impact",
                      desc: "Expanding global reach.",
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // RIGHT VISUAL PANEL (ONLY DESKTOP)
          if (!isMobile) Expanded(flex: 3, child: _buildRightMediaPanel()),
        ],
      ),
    );
  }

  Widget _buildRightMediaPanel() {
    return Center(
      child: SizedBox(
        height: 620,
        width: 620,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌍 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset("assets/images/rnm.png", fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appleCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON (subtle Apple style)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4F46E5), size: 22),
          ),

          const SizedBox(height: 14),

          // TITLE
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 6),

          // DESCRIPTION
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Success Icon
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.deepPurpleAccent,
                        size: 45,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🎉 Title
                    const Text(
                      "Registration Successful",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 📝 Message
                    const Text(
                      "Your registration has been successfully submitted.\nWe will review your details and get back to you soon.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🔘 Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _clearForm();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        // backdropFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: AnimatedOpacity(
            opacity: showRegisterForm ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 4,

                    children: [
                      const Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Fill in your details to complete your registration",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        "All information is securely stored and used only for program coordination",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownField(
                        label: "Title",
                        value: selectedTitle,
                        items: titles,
                        onChanged: (value) {
                          setState(() => selectedTitle = value);
                        },
                      ),
                      _buildTextField(nameController, "Name"),

                      _buildTextField(
                        emailController,
                        "Email",
                        validator: (v) =>
                            v!.contains('@') ? null : "Enter a valid email",
                      ),
                      const SizedBox(height: 4),
                      Row(
                        spacing: 8,
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButtonFormField<String>(
                              value: selectedCountryCode,
                              isExpanded: true, // 🔥 IMPORTANT FIX

                              style: const TextStyle(color: Colors.black),

                              decoration: InputDecoration(
                                labelText: "Code",
                                labelStyle: const TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  167,
                                  157,
                                  157,
                                ).withValues(alpha: 0.2),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white24,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.deepPurpleAccent,
                                    width: 1.5,
                                  ),
                                ),
                              ),

                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.deepPurple,
                              ),

                              dropdownColor: Colors.white,

                              items: countryCodes.map((country) {
                                return DropdownMenuItem(
                                  value: country["code"],
                                  child: Text(
                                    "${country["code"]} (${country["name"]})",
                                    overflow: TextOverflow
                                        .ellipsis, // 🔥 prevents overflow
                                    maxLines: 1,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedCountryCode = value!;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.black),

                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                labelStyle: const TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  167,
                                  157,
                                  157,
                                ).withValues(alpha: 0.2),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white24,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.deepPurpleAccent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildTextField(kcController, "KingsChat Handle"),
                      _buildDropdownField(
                        label: "Nationality",
                        value: selectedNationality,
                        items: nationalities,
                        onChanged: (value) {
                          setState(() => selectedNationality = value);
                        },
                      ),
                      _buildTextField(
                        ceZoneController,
                        "CE Zone (include Campus Ministry)",
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Category / Proficiency",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: skills.map((skill) {
                          final selected = selectedSkills.contains(skill);
                          return FilterChip(
                            label: Text(skill),
                            selected: selected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedSkills.add(skill);
                                } else {
                                  selectedSkills.remove(skill);
                                }
                              });
                            },
                            selectedColor: Colors.deepPurpleAccent,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.white70,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                setState(() => showRegisterForm = false),
                            child: const Text(
                              "Back",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final email = emailController.text.trim().toLowerCase();

      final docRef = FirebaseFirestore.instance
          .collection("registrations")
          .doc(email);

      final doc = await docRef.get();

      if (doc.exists) {
        _showAlreadyRegisteredModal(context);
        return;
      }

      await docRef.set({
        "title": selectedTitle,
        "name": nameController.text,
        "email": email,
        "phone": "$selectedCountryCode${phoneController.text}",
        "nationality": selectedNationality,
        "kc": kcController.text,
        "ceZone": ceZoneController.text,
        "skills": selectedSkills,
        "createdAt": FieldValue.serverTimestamp(),
      });

      showSuccessModal(context);
    } catch (e) {
      print("ERROR: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showAlreadyRegisteredModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.deepPurpleAccent,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                "Already Registered",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You have already registered for this program.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _clearForm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          filled: true,
          fillColor: const Color.fromARGB(
            255,
            167,
            157,
            157,
          ).withValues(alpha: 0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

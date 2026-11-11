import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rhapsody_media_network/services/firestore_service.dart';
import 'package:rhapsody_media_network/widgets/constant.dart';

const _surveyTitles = [
  'Reverend',
  'Pastor',
  'Deacon',
  'Deaconess',
  'Brother',
  'Sister',
];

const _platforms = <({String label, IconData icon})>[
  (label: 'RhapsodyTV.live', icon: Icons.desktop_windows_outlined),
  (label: 'LoveWorld App / CeFlix', icon: Icons.smart_display_outlined),
  (label: 'YouTube', icon: Icons.play_circle_outline),
  (label: 'Satellite', icon: Icons.satellite_alt_outlined),
  (label: 'Rhapsody Mobile App', icon: Icons.phone_iphone),
  (label: 'RTV Mobile App', icon: Icons.live_tv_outlined),
  (label: 'Social Media', icon: Icons.groups_outlined),
  (label: 'Others', icon: Icons.more_horiz),
];

const _programs = [
  'Rhapsody Dailies',
  'Rhapsody Dailies Kiddies',
  'This Morning with Rhapsody of Realities',
  'Rhapsody Travels',
  'Journey to All Languages',
  'Reon Gro',
  'The Day God Spoke My Language',
  'Living Pages',
  'Take 5',
  'Rhapsody of God',
  'Rork TV',
  'The Word Way',
  'No One Left Behind',
  'Beyond the Incredible',
  'Reachout Campaigns',
  'Pastor Chris Worth Hearing',
  'Rhapsody YLW Documentary',
  'Rhapsody Stories',
  'My Rhapsody My Family',
  'Go Deeper',
  'Word in the Street',
  'Rhapsody Healings',
  'Bible Pact',
  'Raised from the Dead',
  'A Billion Testimonies and More',
  'Atmosphere for Miracles',
  'Reachout World Nations',
  'Rhapsody in Nigerian Languages',
  'Rhapsody in South African Languages',
  'Rhapsody on the Digital Frontier',
  'Loveworld Singers',
  'Rhapsody Languages',
  'Reachout World Today',
  'Everyday an Outreach',
  'Other',
];

const _ratings = ['Very Poor', 'Poor', 'Fair', 'Good', 'Excellent'];

const _discovery = [
  'Rhapsody of Realities',
  'KingsChat',
  'YouTube',
  'Social media',
  'A friend',
  'Church',
  'Satellite',
  'Other',
];

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _kc = TextEditingController();
  final _feature = TextEditingController();
  final _suggestions = TextEditingController();
  final _otherPlatform = TextEditingController();
  final _otherDiscovery = TextEditingController();

  String? _title;
  String _countryCode = '+234';
  String? _satisfaction;
  String? _discoveryChoice;
  final Set<String> _platformsSelected = {};
  final Set<String> _programsSelected = {};
  bool _saving = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _kc.dispose();
    _feature.dispose();
    _suggestions.dispose();
    _otherPlatform.dispose();
    _otherDiscovery.dispose();
    super.dispose();
  }

  InputDecoration _field(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),
    );
  }

  Future<void> _pickMany({
    required String title,
    required List<String> options,
    required Set<String> current,
  }) async {
    final draft = {...current};
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
              content: SizedBox(
                width: 440,
                child: ListView(
                  children: [
                    for (final option in options)
                      CheckboxListTile(
                        value: draft.contains(option),
                        activeColor: const Color(0xFF1D4ED8),
                        title: Text(option, style: const TextStyle(color: Colors.black87)),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checked) {
                          setLocal(() {
                            if (checked == true) {
                              draft.add(option);
                            } else {
                              draft.remove(option);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE08A), Color(0xFFE0A325)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x55E0A325), blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.check_circle, size: 18, color: Color(0xFF3B2A06)),
                    label: const Text('Done'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: const Color(0xFF3B2A06),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (saved == true) {
      setState(() {
        current
          ..clear()
          ..addAll(draft);
      });
    }
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;
    if (_platformsSelected.isEmpty) {
      setState(() => _error = 'Choose at least one platform.');
      return;
    }
    if (_platformsSelected.contains('Others') && _otherPlatform.text.trim().isEmpty) {
      setState(() => _error = 'Tell us the other platform you use.');
      return;
    }
    if (_programsSelected.isEmpty) {
      setState(() => _error = 'Choose at least one program.');
      return;
    }
    if (_discoveryChoice == 'Other' && _otherDiscovery.text.trim().isEmpty) {
      setState(() => _error = 'Tell us how you discovered Rhapsody TV.');
      return;
    }
    if (_satisfaction == null) {
      setState(() => _error = 'Choose a satisfaction rating.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final error = await RegistrationService.submitSurvey(
        title: _title!,
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: '$_countryCode${_phone.text.trim()}',
        kc: _kc.text.trim(),
        platforms: [
          for (final platform in _platformsSelected)
            if (platform == 'Others') _otherPlatform.text.trim() else platform,
        ],
        programs: _programsSelected.toList(),
        satisfaction: _satisfaction!,
        newFeature: _feature.text.trim(),
        suggestions: _suggestions.text.trim(),
        discovery: _discoveryChoice == 'Other' ? _otherDiscovery.text.trim() : _discoveryChoice!,
      );
      if (!mounted) return;
      if (error != null) {
        setState(() => _error = error);
        return;
      }
      setState(() => _done = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'The survey could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final footerHeight = MediaQuery.sizeOf(context).width * (52 / 708);
    final reveal = (footerHeight * 0.75 - 28).clamp(0.0, footerHeight).toDouble();
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.45),
            radius: 1.15,
            colors: [Color(0xFF12307A), Color(0xFF0A1458), Color(0xFF1A0848)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SurveyHeader(),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _SurveyFooter(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: reveal),
                    child: Transform.translate(
                      offset: const Offset(0, -8),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 980),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: _card(
                              child: _done ? _thanks() : _form(wide),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thanks() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Color(0xFFD39212), size: 48),
          SizedBox(height: 12),
          Text(
            'Thank you',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your Rhapsody TV partner survey has been received.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }

  Widget _form(bool wide) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section('Section A', 'Personal Details', 'Tell us a little about yourself.'),
          const SizedBox(height: 16),
          _pair(
            wide,
            _labeled(
              '1. Title *',
              DropdownButtonFormField<String>(
                initialValue: _title,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Color(0xFF111827), fontSize: 15),
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                decoration: _field('Select Title', prefix: const Icon(Icons.person_outline, color: Color(0xFF64748B))),
                items: [
                  for (final title in _surveyTitles)
                    DropdownMenuItem(value: title, child: Text(title)),
                ],
                onChanged: (value) => setState(() => _title = value),
                validator: (value) => value == null ? 'Choose a title' : null,
              ),
            ),
            _labeled(
              '2. Full Name *',
              TextFormField(
                controller: _name,
                style: const TextStyle(color: Color(0xFF111827)),
                decoration: _field('Enter your full name', prefix: const Icon(Icons.badge_outlined, color: Color(0xFF64748B))),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter your name' : null,
              ),
            ),
          ),
          _pair(
            wide,
            _labeled(
              '3. Email Address *',
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFF111827)),
                decoration: _field('Enter your email address', prefix: const Icon(Icons.mail_outline, color: Color(0xFF64748B))),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            _labeled(
              '4. Phone Number *',
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: DropdownButtonFormField<String>(
                      initialValue: _countryCode,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Color(0xFF111827), fontSize: 15),
                      decoration: _field(''),
                      selectedItemBuilder: (context) => [
                        for (final country in countryCodes)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${countryFlag(country['iso']!)}  ${country['code']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      items: [
                        for (final country in countryCodes)
                          DropdownMenuItem(
                            value: country['code'],
                            child: Text(
                              '${countryFlag(country['iso']!)}  ${country['code']}  ${country['name']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _countryCode = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(color: Color(0xFF111827)),
                      decoration: _field('Enter your phone number', prefix: const Icon(Icons.phone_outlined, color: Color(0xFF64748B))),
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 4) return 'Enter a phone number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _labeled(
            '5. KingsChat (KC) Handle *',
            TextFormField(
              controller: _kc,
              style: const TextStyle(color: Color(0xFF111827)),
              decoration: _field(
                'Enter your KingsChat handle (e.g. @username)',
                prefix: const _KcMark(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter your KingsChat handle' : null,
            ),
          ),
          const SizedBox(height: 8),
          _section(
            'Section B',
            'Viewing Habits & Familiarity',
            'Tell us how you watch and what you love on Rhapsody TV.',
          ),
          const SizedBox(height: 16),
          const Text.rich(
            TextSpan(
              style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
              children: [
                TextSpan(text: '6. Platform(s) used to watch *  '),
                TextSpan(
                  text: '(Select all that apply)',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final mobile = constraints.maxWidth < 760;
              final columns = mobile ? 2 : 4;
              const gap = 10.0;
              final rowCount = (_platforms.length / columns).ceil();
              return Column(
                children: [
                  for (var row = 0; row < rowCount; row++)
                    Padding(
                      padding: EdgeInsets.only(bottom: row == rowCount - 1 ? 0 : gap),
                      child: Row(
                        children: [
                          for (var column = 0; column < columns; column++) ...[
                            if (column > 0) const SizedBox(width: gap),
                            Expanded(
                              child: () {
                                final index = row * columns + column;
                                if (index >= _platforms.length) {
                                  return mobile
                                      ? const AspectRatio(aspectRatio: 1, child: SizedBox.shrink())
                                      : const SizedBox(height: 92);
                                }
                                final platform = _platforms[index];
                                final tile = _PlatformTile(
                                  label: platform.label,
                                  icon: platform.icon,
                                  selected: _platformsSelected.contains(platform.label),
                                  onTap: () {
                                    setState(() {
                                      if (!_platformsSelected.add(platform.label)) {
                                        _platformsSelected.remove(platform.label);
                                      }
                                    });
                                  },
                                );
                                return mobile ? AspectRatio(aspectRatio: 1, child: tile) : tile;
                              }(),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          if (_platformsSelected.contains('Others')) ...[
            const SizedBox(height: 12),
            _labeled(
              'Other platform *',
              TextFormField(
                controller: _otherPlatform,
                style: const TextStyle(color: Color(0xFF111827)),
                decoration: _field('Type the platform you use'),
                validator: (value) {
                  if (_platformsSelected.contains('Others') && (value == null || value.trim().isEmpty)) {
                    return 'Tell us the other platform';
                  }
                  return null;
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          _pickerField(
            '7. Your Favorite Rhapsody TV Program(s) *',
            _programsSelected,
            'Select program(s)',
            Icons.live_tv_outlined,
            () => _pickMany(
              title: 'Favorite programs',
              options: _programs,
              current: _programsSelected,
            ),
          ),
          const SizedBox(height: 8),
          _section(
            'Section C',
            'Feedback & Suggestions',
            'We value your feedback. It helps us improve your viewing experience.',
          ),
          const SizedBox(height: 16),
          const Text(
            '8. Overall satisfaction rating *',
            style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var index = 0; index < _ratings.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _satisfaction = _ratings[index]),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 34,
                          color: _satisfaction == _ratings[index]
                              ? const Color(0xFFE0A325)
                              : const Color(0xFFB0B6C0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _ratings[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _satisfaction == _ratings[index]
                                ? const Color(0xFF334155)
                                : const Color(0xFFB0B6C0),
                            fontSize: 12,
                            fontWeight: _satisfaction == _ratings[index] ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _labeled(
            '9. What new feature will you like to see on Rhapsody TV? *',
            TextFormField(
              controller: _feature,
              maxLines: 3,
              style: const TextStyle(color: Color(0xFF111827)),
              decoration: _field('E.g. live chat, offline downloads, personalized recommendations, etc.'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Describe a feature' : null,
            ),
          ),
          _labeled(
            '10. Suggestions to improve the viewing experience *',
            TextFormField(
              controller: _suggestions,
              maxLines: 3,
              style: const TextStyle(color: Color(0xFF111827)),
              decoration: _field('Share your ideas, comments or recommendations...'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Share a suggestion' : null,
            ),
          ),
          _labeled(
            '11. How did you discover Rhapsody TV? *',
            DropdownButtonFormField<String>(
              initialValue: _discoveryChoice,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Color(0xFF111827), fontSize: 15),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
              decoration: _field('Select an option', prefix: const Icon(Icons.campaign_outlined, color: Color(0xFF64748B))),
              items: [
                for (final option in _discovery)
                  DropdownMenuItem(value: option, child: Text(option)),
              ],
              onChanged: (value) => setState(() => _discoveryChoice = value),
              validator: (value) => value == null ? 'Choose an option' : null,
            ),
          ),
          if (_discoveryChoice == 'Other')
            _labeled(
              'Other way you discovered Rhapsody TV *',
              TextFormField(
                controller: _otherDiscovery,
                style: const TextStyle(color: Color(0xFF111827)),
                decoration: _field('Type how you discovered Rhapsody TV'),
                validator: (value) {
                  if (_discoveryChoice == 'Other' && (value == null || value.trim().isEmpty)) {
                    return 'Tell us how you discovered Rhapsody TV';
                  }
                  return null;
                },
              ),
            ),
          if (_error != null) _errorText(_error!),
          const SizedBox(height: 8),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE08A), Color(0xFFE0A325)],
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x55E0A325), blurRadius: 16, offset: Offset(0, 6)),
                ],
              ),
              child: FilledButton.icon(
                onPressed: _saving ? null : _submit,
                icon: const Icon(Icons.check_circle, color: Color(0xFF3B2A06)),
                label: Text(_saving ? 'Sending…' : 'Submit Survey'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: const Color(0xFF3B2A06),
                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickerField(
    String label,
    Set<String> selected,
    String empty,
    IconData icon,
    VoidCallback onTap,
  ) {
    final text = selected.isEmpty ? empty : selected.join(', ');
    return _labeled(
      label,
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: _field(empty, prefix: Icon(icon, color: const Color(0xFF64748B))),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pair(bool wide, Widget left, Widget right) {
    if (!wide) {
      return Column(children: [left, right]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _labeled(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          field,
        ],
      ),
    );
  }

  Widget _section(String pill, String title, String note) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(colors: [Color(0xFF123A9A), Color(0xFF1D4ED8)]),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFE08A), Color(0xFFD39212)],
              ),
            ),
            child: Text(
              pill,
              style: const TextStyle(color: Color(0xFF3B2A06), fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          Flexible(
            child: Text(
              note,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D4ED8)),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0x66F6C453), width: 1.2),
          boxShadow: const [
            BoxShadow(color: Color(0x99F6C453), blurRadius: 18, offset: Offset(0, 8)),
            BoxShadow(color: Color(0x887C3AED), blurRadius: 36, offset: Offset(0, 22)),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _errorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(message, style: const TextStyle(color: Color(0xFFDC2626))),
    );
  }
}

class _SurveyHeader extends StatelessWidget {
  const _SurveyHeader();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/survey_banner.png',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }
}

class _SurveyFooter extends StatelessWidget {
  const _SurveyFooter();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/survey_footer.png',
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }
}

class _KcMark extends StatelessWidget {
  const _KcMark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 4),
      child: SvgPicture.asset(
        'assets/images/kingschat.svg',
        width: 22,
        height: 22,
      ),
    );
  }
}

class _SocialLogos extends StatelessWidget {
  const _SocialLogos();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BrandMark(
          color: Color(0xFF1877F2),
          child: Text(
            'f',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: 4),
        _InstagramMark(),
        SizedBox(width: 4),
        _BrandMark(
          color: Color(0xFF111827),
          child: Text(
            '𝕏',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _InstagramMark extends StatelessWidget {
  const _InstagramMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7)],
        ),
      ),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.4),
        ),
        alignment: Alignment.topRight,
        child: Container(
          width: 2.5,
          height: 2.5,
          margin: const EdgeInsets.only(top: 1, right: 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}

class _PlatformTile extends StatelessWidget {
  const _PlatformTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 92,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    label == 'Social Media'
                        ? const _SocialLogos()
                        : Icon(icon, color: const Color(0xFF1D4ED8)),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        label == 'Social Media' ? 'Social Media\n(Facebook, Instagram…)' : label,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.check_circle, size: 18, color: Color(0xFF2563EB)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

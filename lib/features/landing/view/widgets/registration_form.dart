import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/constants/form_options.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/features/landing/viewmodel/landing_view_model.dart';
import 'package:media_network/shared/widgets/web_button.dart';

class RegistrationFormOverlay extends StatelessWidget {
  const RegistrationFormOverlay({
    super.key,
    required this.formKey,
    required this.viewModel,
    required this.onClose,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final LandingViewModel viewModel;
  final VoidCallback onClose;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Positioned.fill(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(color: palette.scrim),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: palette.surfaceModal,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppPalette.light.chipBorder,
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          'Registration',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: palette.textOnModal,
                          ),
                        ),
                        Text(
                          'Fill in your details to complete your registration',
                          style: TextStyle(
                            fontSize: 14,
                            color: palette.textOnModalMuted,
                          ),
                        ),
                        Text(
                          'All information is securely stored and used only for program coordination',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textOnModalMuted.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _DropdownField(
                          label: 'Title',
                          value: viewModel.selectedTitle,
                          items: titles,
                          onChanged: viewModel.setTitle,
                        ),
                        _TextField(
                          controller: viewModel.nameController,
                          label: 'Name',
                        ),
                        _TextField(
                          controller: viewModel.emailController,
                          label: 'Email',
                          validator: (v) =>
                              v != null && v.contains('@') ? null : 'Enter a valid email',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          spacing: 8,
                          children: [
                            SizedBox(
                              width: 140,
                              child: DropdownButtonFormField<String>(
                                initialValue: viewModel.selectedCountryCode,
                                isExpanded: true,
                                style: TextStyle(color: palette.textOnModal),
                                decoration: _inputDecoration(context, 'Code'),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: palette.accentPurple,
                                ),
                                dropdownColor: palette.surfaceModal,
                                items: countryCodes
                                    .map(
                                      (country) => DropdownMenuItem(
                                        value: country['code'],
                                        child: Text(
                                          '${country['code']} (${country['name']})',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(color: palette.textOnModal),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) viewModel.setCountryCode(value);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: viewModel.phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: palette.textOnModal),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: _inputDecoration(context, 'Phone Number'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _TextField(
                          controller: viewModel.kcController,
                          label: 'KingsChat Handle',
                        ),
                        _DropdownField(
                          label: 'Nationality',
                          value: viewModel.selectedNationality,
                          items: nationalities,
                          onChanged: viewModel.setNationality,
                        ),
                        _TextField(
                          controller: viewModel.ceZoneController,
                          label: 'CE Zone (include Campus Ministry)',
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Category / Proficiency',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: palette.accentPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: skills.map((skill) {
                            final selected = viewModel.selectedSkills.contains(skill);
                            return FilterChip(
                              label: Text(skill),
                              selected: selected,
                              onSelected: (value) =>
                                  viewModel.toggleSkill(skill, value),
                              selectedColor: palette.accentPurple,
                              backgroundColor: AppPalette.light.chipFill,
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : palette.textOnModalMuted,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: onClose,
                              child: Text(
                                'Back',
                                style: TextStyle(color: palette.accentPurple),
                              ),
                            ),
                            viewModel.isLoading
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: palette.accentPurple,
                                  )
                                : WebButton(
                                    decoration: boxDecoration,
                                    textColor: Colors.white,
                                    onPressed:
                                        viewModel.isLoading ? null : onSubmit,
                                    bodytext: 'Submit',
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
      ),
    );
  }
}

InputDecoration _inputDecoration(BuildContext context, String label) {
  final palette = context.palette;
  final scheme = Theme.of(context).colorScheme;

  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: palette.accentPurple),
    filled: true,
    fillColor: AppPalette.light.chipFill,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppPalette.light.chipBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: palette.accentPurple,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.error),
    ),
  );
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: palette.textOnModal),
        validator: validator,
        decoration: _inputDecoration(context, label),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        style: TextStyle(color: palette.textOnModal),
        decoration: _inputDecoration(context, label),
        icon: Icon(Icons.arrow_drop_down, color: palette.accentPurple),
        dropdownColor: palette.surfaceModal,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: palette.textOnModal),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Please select $label' : null,
      ),
    );
  }
}

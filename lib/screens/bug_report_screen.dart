import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../models/feedback_form_state.dart';
import '../models/media_file.dart';
import '../theme/app_theme.dart';
import '../widgets/section_card.dart';
import '../widgets/form_widgets.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late FeedbackFormState formState;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Reset the form state when opening this screen
    Future.microtask(() {
      formState = Provider.of<FeedbackFormState>(context, listen: false);
      formState.resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Bug Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<FeedbackFormState>(
        builder: (context, formState, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryLight.withOpacity(0.3),
                      Colors.white,
                    ],
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPageTitle(context),
                            if (formState.showDocumentationBox) _buildDocumentationBox(context, formState),
                            SectionCard(
                              title: 'Product Information',
                              content: _buildProductInfoSection(context, formState),
                            ),
                            SectionCard(
                              title: 'Issue Details',
                              content: _buildIssueDetailsSection(context, formState),
                            ),
                            SectionCard(
                              title: 'Media Attachments',
                              content: _buildMediaAttachmentsSection(context, formState),
                            ),
                            SectionCard(
                              title: 'Best Practices',
                              content: _buildBestPracticesContent(context),
                            ),
                            _buildAcknowledgment(context),
                            const SizedBox(height: 16),
                            _buildSubmitButton(context, formState),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isSubmitting) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  // Section Builder Methods
  
  Widget _buildProductInfoSection(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductDropdown(context, formState),
        const SizedBox(height: 16),
        _buildUnityVersionDropdown(context, formState),
        if (formState.selectedUnityVersion == 'other')
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildOtherUnityVersionField(formState),
          ),
      ],
    );
  }

  Widget _buildIssueDetailsSection(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBugTitleField(context, formState),
        const SizedBox(height: 16),
        _buildBugDescriptionField(context, formState),
      ],
    );
  }

  Widget _buildMediaAttachmentsSection(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'At least 2 files required',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray,
              ),
            ),
            Text(
              'Uploaded: ${formState.mediaFiles.length}/2 required files',
              style: TextStyle(
                fontSize: 14,
                color: formState.mediaFiles.length < 2 ? AppTheme.danger : AppTheme.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickFiles(formState),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.gray,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: AppTheme.gray,
                ),
                const SizedBox(height: 12),
                Text(
                  'Drag & drop files here or click to upload',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _pickFiles(formState),
                  child: const Text('Choose Files'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildMediaRequirements(context),
        if (formState.mediaFiles.isNotEmpty) const SizedBox(height: 16),
        if (formState.mediaFiles.isNotEmpty) _buildMediaPreview(context, formState),
      ],
    );
  }

  // UI Component Builders
  Widget _buildPageTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(
            Icons.bug_report,
            size: 28,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            'Bug Report Form',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentationBox(BuildContext context, FeedbackFormState formState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primary,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Before submitting a bug report:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => formState.hideDocumentationBox(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Have you checked our documentation? Issues are resolved 78% faster when users consult documentation first.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.book),
                label: const Text('View Documentation'),
                onPressed: () => _showDocumentation(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_filled),
                label: const Text('Watch Quick Guide (2 min)'),
                onPressed: () => _showVideoGuide(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown(BuildContext context, FeedbackFormState formState) {
    final List<Map<String, String>> products = [
      {'value': 'product1', 'label': 'Hash Studios Asset Pack 1'},
      {'value': 'product2', 'label': 'RuntimeMeshMaker Pro'},
      {'value': 'product3', 'label': 'Advanced Animation System'},
      {'value': 'product4', 'label': 'Dynamic Weather Effects'},
      {'value': 'product5', 'label': 'Procedural Terrain Generator'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Software Product / Service Name: *',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: formState.selectedProduct.isEmpty ? null : formState.selectedProduct,
          decoration: const InputDecoration(
            hintText: 'Select a product',
          ),
          items: products.map((product) {
            return DropdownMenuItem<String>(
              value: product['value'],
              child: Text(product['label']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              formState.updateProduct(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a product';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUnityVersionDropdown(BuildContext context, FeedbackFormState formState) {
    final List<Map<String, String>> unityVersions = [
      {'value': '2022.3', 'label': 'Unity 2022.3 (LTS)'},
      {'value': '2022.2', 'label': 'Unity 2022.2'},
      {'value': '2022.1', 'label': 'Unity 2022.1'},
      {'value': '2021.3', 'label': 'Unity 2021.3 (LTS)'},
      {'value': '2021.2', 'label': 'Unity 2021.2'},
      {'value': '2021.1', 'label': 'Unity 2021.1'},
      {'value': '2020.3', 'label': 'Unity 2020.3 (LTS)'},
      {'value': 'other', 'label': 'Other (Please specify)'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unity Version: *',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: formState.selectedUnityVersion.isEmpty ? null : formState.selectedUnityVersion,
          decoration: const InputDecoration(
            hintText: 'Select Unity version',
          ),
          items: unityVersions.map((version) {
            return DropdownMenuItem<String>(
              value: version['value'],
              child: Text(version['label']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              formState.updateUnityVersion(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a Unity version';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOtherUnityVersionField(FeedbackFormState formState) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Please specify your Unity version',
      ),
      onChanged: (value) => formState.updateOtherUnityVersion(value),
      validator: (value) {
        if (formState.selectedUnityVersion == 'other' && (value == null || value.isEmpty)) {
          return 'Please specify your Unity version';
        }
        return null;
      },
    );
  }

  Widget _buildBugTitleField(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title of problem you\'re facing: (4 words maximum) *',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Example: Prefab Animation Not Working',
            counterText: '${30 - formState.bugTitle.length} characters remaining (approx. 4 words)',
            counterStyle: TextStyle(
              color: formState.bugTitle.split(' ').length > 4 ? AppTheme.danger : AppTheme.gray,
            ),
          ),
          maxLength: 30,
          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
          onChanged: (value) => formState.updateBugTitle(value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a title';
            }
            if (value.split(' ').length > 4) {
              return 'Title must be 4 words or less';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBugDescriptionField(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description: (Minimum 2 full sentences) *',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Please describe the issue in detail. What were you trying to do? What happened instead? What steps can we take to reproduce this issue? Any error messages you received?',
            counterText: '${formState.bugDescription.length}/150 characters minimum',
            counterStyle: TextStyle(
              color: formState.bugDescription.length < 150 ? AppTheme.danger : AppTheme.success,
            ),
          ),
          maxLines: 5,
          onChanged: (value) => formState.updateBugDescription(value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a description';
            }
            if (value.length < 150) {
              return 'Description must be at least 150 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMediaRequirements(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Required screenshots:',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 8),
          Text('1. Unity Hierarchy view showing your setup'),
          Text('2. Inspector panel showing component settings'),
          const SizedBox(height: 12),
          Text(
            'Additional helpful attachments:',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 8),
          Text('• Console log'),
          Text('• Video of the issue occurring'),
          Text('• Unity project logs'),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context, FeedbackFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uploaded Files:',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: formState.mediaFiles.map((file) {
            return MediaItem(
              file: file,
              onRemove: () => formState.removeMediaFile(file),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBestPracticesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: AppTheme.warning,
            ),
            const SizedBox(width: 8),
            Text(
              'DID YOU KNOW?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatBox(
          icon: Icons.speed,
          text: 'Bug reports with clear reproduction steps are resolved 3x faster than vague reports.',
        ),
        const SizedBox(height: 12),
        StatBox(
          icon: Icons.image,
          text: 'Reports with screenshots are addressed 65% sooner than those without visual evidence.',
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHAT WE NEED TO HELP YOU:',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const GoodPracticeItem(text: 'Clear steps to reproduce the issue'),
                  const GoodPracticeItem(text: 'Screenshots of your setup'),
                  const GoodPracticeItem(text: 'Unity version and other relevant system info'),
                  const GoodPracticeItem(text: 'What you expected vs. what actually happened'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHAT DOESN\'T HELP:',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const BadPracticeItem(text: '"It doesn\'t work"'),
                  const BadPracticeItem(text: '"Please fix ASAP"'),
                  const BadPracticeItem(text: 'Reporting multiple issues in one report'),
                  const BadPracticeItem(text: 'Missing required information'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAcknowledgment(BuildContext context) {
    return Text(
      'By submitting this form, you acknowledge you\'ve provided all required information to the best of your ability.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: AppTheme.gray,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, FeedbackFormState formState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _submitForm(context, formState),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Submit Bug Report'),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white70,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Helper Methods
  Future<void> _pickFiles(FeedbackFormState formState) async {
    try {
      List<MediaFile> newFiles = [];
      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.media,
          allowMultiple: true,
        );

        if (result != null) {
          for (var file in result.files) {
            if (file.bytes != null) {
              final isImage = file.extension?.toLowerCase() == 'jpg' ||
                  file.extension?.toLowerCase() == 'jpeg' ||
                  file.extension?.toLowerCase() == 'png' ||
                  file.extension?.toLowerCase() == 'gif';

              newFiles.add(MediaFile(
                name: file.name,
                bytes: file.bytes,
                isImage: isImage,
              ));
            }
          }
        }
      } else {
        // Native platforms
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage();

        for (var image in images) {
          newFiles.add(MediaFile(
            name: image.name,
            path: image.path,
            isImage: true,
          ));
        }
      }

      if (newFiles.isNotEmpty) {
        formState.addMediaFiles(newFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  void _showDocumentation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documentation'),
        content: const Text(
          'The documentation for this product would be displayed here. '
          'This is a placeholder for demonstration purposes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVideoGuide() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('How to Submit an Effective Bug Report'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context, FeedbackFormState formState) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.success,
              ),
              const SizedBox(width: 8),
              const Text('Bug Report Submitted'),
            ],
          ),
          content: const Text(
            'Thank you for your bug report! Our team will review it shortly and take appropriate action. You\'ll receive a confirmation email with your ticket number.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home screen
              },
              child: const Text('Return to Home'),
            ),
          ],
        ),
      );
    }
  }
}
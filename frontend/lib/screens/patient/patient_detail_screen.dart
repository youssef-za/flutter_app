import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/emotion_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../models/emotion_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/emotion_chart.dart';
import '../../widgets/emotion_card.dart';
import '../../widgets/modern_card.dart';
import '../../providers/patient_note_provider.dart';
import '../../models/patient_note_model.dart';
import '../../services/pdf_report_service.dart';
import '../../providers/emotion_statistics_provider.dart';
import '../../providers/patient_tag_provider.dart';
import '../../models/patient_tag_model.dart';
import '../../services/api_service.dart';

class PatientDetailScreen extends StatefulWidget {
  final UserModel patient;

  const PatientDetailScreen({
    super.key,
    required this.patient,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatientEmotions();
    });
  }

  Future<void> _loadPatientEmotions() async {
    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    final noteProvider = Provider.of<PatientNoteProvider>(context, listen: false);
    final tagProvider = Provider.of<PatientTagProvider>(context, listen: false);
    final statisticsProvider = Provider.of<EmotionStatisticsProvider>(context, listen: false);
    
    await Future.wait([
      emotionProvider.loadEmotionHistory(widget.patient.id),
      noteProvider.loadNotesByPatientId(widget.patient.id),
      tagProvider.loadTagsByPatientId(widget.patient.id),
      statisticsProvider.loadStatistics(widget.patient.id),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.fullName),
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.currentUser?.isDoctor == true) {
                return IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Generate PDF Report',
                  onPressed: () => _generatePdfReport(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPatientEmotions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Patient Info Card
              _buildPatientInfoCard(colorScheme),
              const SizedBox(height: 20),

              // Charts Section
              Consumer<EmotionProvider>(
                builder: (context, emotionProvider, _) {
                  if (emotionProvider.isLoading) {
                    return const LoadingWidget(message: 'Loading emotions...');
                  }

                  if (emotionProvider.emotions.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.sentiment_neutral,
                      title: 'No emotions recorded',
                      message: 'This patient has not recorded any emotions yet',
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Line Chart
                      EmotionChart(
                        emotions: emotionProvider.emotions,
                        chartType: ChartType.line,
                      ),
                      const SizedBox(height: 20),

                      // Bar Chart
                      EmotionChart(
                        emotions: emotionProvider.emotions,
                        chartType: ChartType.bar,
                      ),
                      const SizedBox(height: 20),

                      // Pie Chart
                      EmotionChart(
                        emotions: emotionProvider.emotions,
                        chartType: ChartType.pie,
                      ),
                      const SizedBox(height: 20),

                      // Patient Tags Section
                      _buildTagsSection(),
                      const SizedBox(height: 20),

                      // Patient Notes Section
                      _buildNotesSection(),
                      const SizedBox(height: 20),

                      // Emotion History List
                      const Text(
                        'Emotion History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...emotionProvider.emotions.map((emotion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: EmotionCard(emotion: emotion),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.currentUser?.isDoctor == true) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddNoteDialog(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<PatientNoteProvider>(
          builder: (context, noteProvider, _) {
            if (noteProvider.isLoading) {
              return const LoadingWidget(message: 'Loading notes...');
            }

            final patientNotes = noteProvider.notes
                .where((n) => n.patientId == widget.patient.id)
                .toList();

            if (patientNotes.isEmpty) {
              return ModernCard(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.note_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: patientNotes.map((note) {
                return ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            note.doctorName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy HH:mm').format(note.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.note,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          if (authProvider.currentUser?.id == note.doctorId) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _showEditNoteDialog(note),
                                  child: const Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () => _deleteNote(note.id),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  void _showAddNoteDialog() {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: noteController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (noteController.text.isNotEmpty) {
                final noteProvider = Provider.of<PatientNoteProvider>(context, listen: false);
                final success = await noteProvider.createNote(
                  widget.patient.id,
                  noteController.text,
                );
                if (success && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(PatientNoteModel note) {
    final noteController = TextEditingController(text: note.note);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: noteController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (noteController.text.isNotEmpty) {
                final noteProvider = Provider.of<PatientNoteProvider>(context, listen: false);
                final success = await noteProvider.updateNote(
                  note.id,
                  noteController.text,
                );
                if (success && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(int noteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final noteProvider = Provider.of<PatientNoteProvider>(context, listen: false);
      final success = await noteProvider.deleteNote(noteId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _generatePdfReport() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
      final noteProvider = Provider.of<PatientNoteProvider>(context, listen: false);
      final statisticsProvider = Provider.of<EmotionStatisticsProvider>(context, listen: false);

      // Ensure data is loaded
      if (emotionProvider.emotions.isEmpty) {
        await emotionProvider.loadEmotionHistory(widget.patient.id);
      }
      if (noteProvider.notes.where((n) => n.patientId == widget.patient.id).isEmpty) {
        await noteProvider.loadNotesByPatientId(widget.patient.id);
      }
      if (statisticsProvider.statistics == null) {
        await statisticsProvider.loadStatistics(widget.patient.id);
      }

      // Calculate emotion frequency
      final emotionFrequency = <String, int>{};
      for (var emotion in emotionProvider.emotions) {
        emotionFrequency[emotion.emotionType] =
            (emotionFrequency[emotion.emotionType] ?? 0) + 1;
      }

      // Get patient notes
      final patientNotes = noteProvider.notes
          .where((n) => n.patientId == widget.patient.id)
          .toList();

      // Get statistics
      final stats = statisticsProvider.statistics;
      final stressLevel = stats?['stressLevel'] as int? ?? 0;
      final mostFrequentEmotion = stats?['mostFrequentEmotion'] as String? ?? 'NEUTRAL';

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Generate PDF
      final pdfService = PdfReportService();
      await pdfService.generatePatientReport(
        patient: widget.patient,
        emotions: emotionProvider.emotions,
        notes: patientNotes,
        emotionFrequency: emotionFrequency,
        stressLevel: stressLevel,
        mostFrequentEmotion: mostFrequentEmotion,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF report generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPatientInfoCard(ColorScheme colorScheme) {
    return ModernCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        widget.patient.fullName.isNotEmpty
                            ? widget.patient.fullName[0].toUpperCase()
                            : 'P',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.patient.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.patient.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (widget.patient.age != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Age: ${widget.patient.age}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    if (widget.patient.gender != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Gender: ${widget.patient.gender}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  if (authProvider.currentUser?.isDoctor == true) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Patient Information',
                      onPressed: () => _showEditPatientDialog(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.currentUser?.isDoctor == true) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddTagDialog(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<PatientTagProvider>(
          builder: (context, tagProvider, _) {
            if (tagProvider.isLoading) {
              return const LoadingWidget(message: 'Loading tags...');
            }

            final patientTags = tagProvider.getTagsByPatientId(widget.patient.id);

            if (patientTags.isEmpty) {
              return ModernCard(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.label_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No tags yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: patientTags.map((tag) {
                return Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    final canDelete = authProvider.currentUser?.id == tag.doctorId;
                    return Chip(
                      label: Text(tag.tag),
                      deleteIcon: canDelete ? const Icon(Icons.close, size: 18) : null,
                      onDeleted: canDelete
                          ? () => _removeTag(tag.id, tag.tag)
                          : null,
                      backgroundColor: _getTagColor(tag.tag).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getTagColor(tag.tag),
                        fontWeight: FontWeight.bold,
                      ),
                      side: BorderSide(color: _getTagColor(tag.tag)),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'follow-up':
        return Colors.orange;
      case 'stable':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  void _showAddTagDialog() {
    final tagController = TextEditingController();
    final commonTags = ['urgent', 'follow-up', 'stable', 'monitoring', 'improving'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                hintText: 'Enter tag name...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Common tags:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: commonTags.map((tag) {
                return ActionChip(
                  label: Text(tag),
                  onPressed: () {
                    tagController.text = tag;
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (tagController.text.isNotEmpty) {
                final tagProvider = Provider.of<PatientTagProvider>(context, listen: false);
                final success = await tagProvider.addTag(
                  widget.patient.id,
                  tagController.text.trim(),
                );
                if (success && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tag added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tagProvider.errorMessage ?? 'Failed to add tag'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeTag(int tagId, String tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Tag'),
        content: Text('Are you sure you want to remove the tag "$tag"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final tagProvider = Provider.of<PatientTagProvider>(context, listen: false);
      final success = await tagProvider.removeTagById(tagId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tag removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showEditPatientDialog() {
    final nameController = TextEditingController(text: widget.patient.fullName);
    final emailController = TextEditingController(text: widget.patient.email);
    final ageController = TextEditingController(
      text: widget.patient.age?.toString() ?? '',
    );
    String? selectedGender = widget.patient.gender;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Patient Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'MALE', child: Text('Male')),
                  DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                  DropdownMenuItem(value: 'PREFER_NOT_TO_SAY', child: Text('Prefer not to say')),
                ],
                onChanged: (value) {
                  selectedGender = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final apiService = ApiService();
                final age = ageController.text.isNotEmpty
                    ? int.tryParse(ageController.text)
                    : null;
                
                final response = await apiService.updatePatientInfo(
                  widget.patient.id,
                  nameController.text.trim(),
                  emailController.text.trim(),
                  age: age,
                  gender: selectedGender,
                );
                
                if (response.statusCode == 200 && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Patient information updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reload patient data
                  _loadPatientEmotions();
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update patient information'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}


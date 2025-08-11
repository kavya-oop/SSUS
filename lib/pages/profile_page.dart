import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/bottom_nav_bar.dart';
import '../services/page_transitions.dart';
import '../pages/settings_page.dart';
import '../services/supabase/user_profile_funcs.dart';
import '../services/supabase/user_profile_enums.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _preferencesController = TextEditingController();

  // Form data
  int? _selectedStatus;
  int? _selectedSexuality;

  bool _isLoading = true;
  bool _isSaving = false;

  // Get status and sexuality options from enums
  List<Map<String, dynamic>> get _statusOptions => UserStatus.getOptions();
  List<Map<String, dynamic>> get _sexualityOptions =>
      UserSexuality.getOptions();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Get current user
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
        return;
      }

      // Fetch user profile data
      final response = await _supabase
          .from('user_profile')
          .select()
          .eq('id', user.id)
          .single();

      if (!mounted) return;

      // Populate form fields
      _firstNameController.text = response['first_name']?.toString() ?? '';
      _lastNameController.text = response['last_name']?.toString() ?? '';
      _ageController.text = response['age']?.toString() ?? '';
      _selectedStatus =
          response['status'] as int? ??
          UserStatus.single.value; // Use enum default
      _selectedSexuality =
          response['sexuality'] as int? ??
          UserSexuality.preferNotToSay.value; // Use enum default

      // Handle preferences array
      final preferences = response['preferences'] as List<dynamic>?;
      _preferencesController.text = preferences?.join(', ') ?? '';
    } catch (error) {
      // Check if it's a "no rows" error specifically
      if (error.toString().contains('No rows returned') ||
          error.toString().contains('No rows found')) {
        // No profile exists yet, create a default one
        try {
          await createUserProfileRow();

          if (!mounted) return;

          // Set default values for the form
          _selectedStatus = UserStatus.single.value; // Use enum default
          _selectedSexuality =
              UserSexuality.preferNotToSay.value; // Use enum default
          _preferencesController.text = '';
        } catch (createError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error creating profile: $createError')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile: $error')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Parse preferences from comma-separated string to array
      final preferencesText = _preferencesController.text.trim();
      final preferencesArray = preferencesText.isNotEmpty
          ? preferencesText.split(',').map((e) => e.trim()).toList()
          : <String>[];

      // Ensure required fields are not null
      if (_selectedStatus == null || _selectedSexuality == null) {
        throw Exception('Status and sexuality are required');
      }

      // Use the new updateUserProfileRow function
      await updateUserProfileRow(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        int.tryParse(_ageController.text.trim()) ?? 0,
        _selectedStatus!,
        _selectedSexuality!,
        preferencesArray,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving profile: $error')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () =>
                PageTransitions.navigateTo(context, SettingsPage()),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Age is required';
                        }
                        final age = int.tryParse(value!);
                        if (age == null || age < 18 || age > 120) {
                          return 'Please enter a valid age (18-120)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status
                    DropdownButtonFormField<int>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: _statusOptions.map((option) {
                        return DropdownMenuItem<int>(
                          value: option['value'] as int,
                          child: Text(option['label'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Status is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sexuality
                    DropdownButtonFormField<int>(
                      value: _selectedSexuality,
                      decoration: const InputDecoration(
                        labelText: 'Sexuality',
                        border: OutlineInputBorder(),
                      ),
                      items: _sexualityOptions.map((option) {
                        return DropdownMenuItem<int>(
                          value: option['value'] as int,
                          child: Text(option['label'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSexuality = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Sexuality is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Preferences
                    TextFormField(
                      controller: _preferencesController,
                      decoration: const InputDecoration(
                        labelText: 'Preferences',
                        border: OutlineInputBorder(),
                        hintText: 'Enter preferences separated by commas',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Save Button (alternative to app bar button)
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      child: _isSaving
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Saving...'),
                              ],
                            )
                          : const Text('Save Profile'),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}

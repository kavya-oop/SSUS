import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth/auth_service.dart';
import '../../services/supabase/user_profile_funcs.dart';
import '../../services/supabase/user_profile_enums.dart';
import '../../services/page_transitions.dart';
import '../SUS_page.dart';

class SignupFlowPage extends StatefulWidget {
  const SignupFlowPage({super.key});

  @override
  State<SignupFlowPage> createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlowPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Form data
  int? _selectedStatus;
  int? _selectedSexuality;
  final List<TextEditingController> _preferenceControllers = [
    TextEditingController(),
  ];

  bool _isLoading = false;

  // Get status and sexuality options from enums
  List<Map<String, dynamic>> get _statusOptions => UserStatus.getOptions();
  List<Map<String, dynamic>> get _sexualityOptions =>
      UserSexuality.getOptions();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    for (var controller in _preferenceControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      if (_validateRequiredFields()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getValidationMessage()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateRequiredFields() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _ageController.text.trim().isNotEmpty &&
        _selectedStatus != null &&
        int.tryParse(_ageController.text) != null &&
        int.parse(_ageController.text) >= 13 &&
        int.parse(_ageController.text) <= 120;
  }

  String _getValidationMessage() {
    print('getValidationMessage');
    final missingFields = <String>[];

    if (_firstNameController.text.trim().isEmpty) {
      missingFields.add('Fill in first name');
    }

    if (_lastNameController.text.trim().isEmpty) {
      missingFields.add('Fill in last name');
    }

    if (_ageController.text.trim().isEmpty) {
      missingFields.add('Fill in age');
    } else if (int.parse(_ageController.text) < 13 ||
        int.parse(_ageController.text) > 120) {
      missingFields.add('Age must be between 13 and 120');
    }

    if (_selectedStatus == null) {
      missingFields.add('Select relationship status');
    }

    if (missingFields.isEmpty) {
      return ''; // No missing fields
    }
    return '${missingFields.join('\n')}.';
  }

  List<String> _getPreferencesAsList() {
    final preferences = <String>[];
    for (var controller in _preferenceControllers) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        preferences.add(text);
      }
    }
    return preferences;
  }

  Future<void> _submitProfile() async {
    if (!_validateRequiredFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID from auth service
      final authService = AuthService();
      final currentUser = authService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Use the new upsertUserProfileRow function
      await upsertUserProfileRow(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        int.parse(_ageController.text),
        _selectedStatus!,
        _selectedSexuality ??
            UserSexuality.preferNotToSay.value, // Use enum default
        _getPreferencesAsList(),
        true, // signupFlowCompleted = true since this is the signup flow
      );

      if (mounted) {
        // Navigate to SUSPage using PageTransitions
        PageTransitions.replaceWith(context, const SUSPage());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile (${_currentPage + 1}/2)'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => PageTransitions.logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          // Prevent navigation to optional fields page if required fields are not filled
          if (page == 1 && !_validateRequiredFields()) {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please complete all required fields first'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          setState(() {
            _currentPage = page;
          });
        },
        children: [_buildRequiredFieldsPage(), _buildOptionalFieldsPage()],
      ),
    );
  }

  //required fields page
  Widget _buildRequiredFieldsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Required Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please fill in the following required fields to continue.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name *',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name *',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age *',
                      border: OutlineInputBorder(),
                      helperText: 'Must be between 13 and 120',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 24),

                  // Status
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Relationship Status *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._statusOptions.map(
                    (option) => RadioListTile<int>(
                      title: Text(option['label']),
                      value: option['value'],
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                //backgroundColor: _validateRequiredFields() ? null : Colors.grey,
              ),
              child: const Text('Continue to Optional Fields'),
            ),
          ),
        ],
      ),
    );
  }

  //optional fields page
  Widget _buildOptionalFieldsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Optional Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'These fields are optional but help us provide a better experience.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sexuality
                  const Text(
                    'Sexuality',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedSexuality,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select your sexuality (optional)',
                    ),
                    items: _sexualityOptions.map((Map<String, dynamic> option) {
                      return DropdownMenuItem<int>(
                        value: option['value'],
                        child: Text(option['label']),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedSexuality = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Preferences
                  const Text(
                    'Preferences/Little About You',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'i.e. I want something serious, I have a dog so must like dogs, etc.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // Dynamic preference text inputs
                  ..._preferenceControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: 'Preference',
                                border: const OutlineInputBorder(),
                                //hintText: 'e.g., I want something serious',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_preferenceControllers.length > 1)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.dispose();
                                  _preferenceControllers.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              tooltip: 'Remove preference',
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Add new preference button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _preferenceControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Another Preference'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Complete Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

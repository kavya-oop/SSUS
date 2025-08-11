import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_profile_enums.dart';

Future<bool> loadUserProfileSignUpFlowCompleted() async {
  final supabase = Supabase.instance.client;

  // Get current user
  final user = supabase.auth.currentUser;

  // Fetch user profile data
  return await supabase
      .from('user_profile')
      .select('signup_flow_completed')
      .eq('id', user!.id)
      .single()
      .then((value) => value['signup_flow_completed']);
}

//create new row in user_profile table
Future<void> createUserProfileRow() async {
  final supabase = Supabase.instance.client;

  // Get current user
  final user = supabase.auth.currentUser;

  // Create new row in user_profile table
  await supabase.from('user_profile').insert({
    'id': user!.id,
    'signup_flow_completed': false,
  });
}

//---------------------------------

/* Update/insert commands for user_profile table
*  id: user id (pulled from auth.currentUser) - primary key uuid
*  first_name: first name of user - varchar
*  last_name: last name of user - varchar
*  age: age of user - int
*  status: status of user - int
*  sexuality: sexuality of user - int
*  preferences: preferences of user - array of strings
*  signup_flow_completed: whether the user has completed the signup flow - boolean
*/

//upsert user_profile table with input values
//usually only called when user is first signing up, so signupFlowCompleted is true
Future<void> upsertUserProfileRow(
  String firstName,
  String lastName,
  int age,
  int status,
  int sexuality,
  List<String> preferences,
  bool signupFlowCompleted,
) async {
  final supabase = Supabase.instance.client;

  // Get current user
  final user = supabase.auth.currentUser;

  await supabase.from('user_profile').upsert({
    'id': user!.id,
    'first_name': firstName,
    'last_name': lastName,
    'age': age,
    'status': status,
    'sexuality': sexuality,
    'preferences': preferences,
    'signup_flow_completed': signupFlowCompleted,
  });
}

//update user_profile table with input values
Future<void> updateUserProfileRow(
  String firstName,
  String lastName,
  int age,
  int status,
  int sexuality,
  List<String> preferences,
) async {
  final supabase = Supabase.instance.client;

  // Get current user
  final user = supabase.auth.currentUser;

  await supabase
      .from('user_profile')
      .update({
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'status': status,
        'sexuality': sexuality,
        'preferences': preferences,
      })
      .eq('id', user!.id);
}

//---------------------------------

// Helper functions for better type safety using enums

/// Get user status label from integer value
String getUserStatusLabel(int statusValue) {
  return UserStatus.fromValue(statusValue).label;
}

/// Get user sexuality label from integer value
String getUserSexualityLabel(int sexualityValue) {
  return UserSexuality.fromValue(sexualityValue).label;
}

/// Validate if a status value is valid
bool isValidStatus(int statusValue) {
  return UserStatus.values.any((status) => status.value == statusValue);
}

/// Validate if a sexuality value is valid
bool isValidSexuality(int sexualityValue) {
  return UserSexuality.values.any(
    (sexuality) => sexuality.value == sexualityValue,
  );
}

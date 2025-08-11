import 'user_profile_enums.dart';

/// Utility functions for working with user profile data
class UserProfileUtils {
  /// Get a formatted string representation of user status and sexuality
  static String formatUserProfile(int status, int sexuality) {
    final statusLabel = UserStatus.fromValue(status).label;
    final sexualityLabel = UserSexuality.fromValue(sexuality).label;
    return '$statusLabel • $sexualityLabel';
  }

  /// Check if a user profile is complete (has all required fields)
  static bool isProfileComplete({
    required String? firstName,
    required String? lastName,
    required int? age,
    required int? status,
    required int? sexuality,
  }) {
    return firstName?.isNotEmpty == true &&
        lastName?.isNotEmpty == true &&
        age != null &&
        age > 0 &&
        status != null &&
        sexuality != null;
  }

  /// Get a list of all available status options with their values
  static List<Map<String, dynamic>> getAllStatusOptions() {
    return UserStatus.getOptions();
  }

  /// Get a list of all available sexuality options with their values
  static List<Map<String, dynamic>> getAllSexualityOptions() {
    return UserSexuality.getOptions();
  }

  /// Get status label by value
  static String getStatusLabel(int value) {
    return UserStatus.fromValue(value).label;
  }

  /// Get sexuality label by value
  static String getSexualityLabel(int value) {
    return UserSexuality.fromValue(value).label;
  }

  /// Validate status value
  static bool isValidStatus(int value) {
    return UserStatus.values.any((status) => status.value == value);
  }

  /// Validate sexuality value
  static bool isValidSexuality(int value) {
    return UserSexuality.values.any((sexuality) => sexuality.value == value);
  }
}

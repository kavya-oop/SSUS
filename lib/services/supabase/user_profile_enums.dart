/// Enums for user profile data to ensure consistency between UI and database
/// These enums map integer values to their corresponding string labels

enum UserStatus {
  single(0, 'Single'),
  takenNotLooking(1, 'Taken/Not looking'),
  takenOpenToPoly(2, 'Taken - but open to poly'),
  complicated(3, 'It\'s complicated');

  const UserStatus(this.value, this.label);

  final int value;
  final String label;

  /// Get enum from integer value
  static UserStatus fromValue(int value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.single, // Default to single
    );
  }

  /// Get all options for UI dropdowns
  static List<Map<String, dynamic>> getOptions() {
    return UserStatus.values
        .map((status) => {'value': status.value, 'label': status.label})
        .toList();
  }
}

enum UserSexuality {
  heterosexual(0, 'Heterosexual'),
  homosexual(1, 'Homosexual'),
  bisexual(2, 'Bisexual'),
  pansexual(3, 'Pansexual'),
  asexual(4, 'Asexual'),
  preferNotToSay(5, 'Prefer not to say'),
  other(6, 'Other');

  const UserSexuality(this.value, this.label);

  final int value;
  final String label;

  /// Get enum from integer value
  static UserSexuality fromValue(int value) {
    return UserSexuality.values.firstWhere(
      (sexuality) => sexuality.value == value,
      orElse: () =>
          UserSexuality.preferNotToSay, // Default to prefer not to say
    );
  }

  /// Get all options for UI dropdowns
  static List<Map<String, dynamic>> getOptions() {
    return UserSexuality.values
        .map(
          (sexuality) => {'value': sexuality.value, 'label': sexuality.label},
        )
        .toList();
  }
}

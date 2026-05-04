class AppUser {
  final String uid;
  final String email;
  final bool isEmailVerified;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.isEmailVerified,
    this.createdAt,
  });
}
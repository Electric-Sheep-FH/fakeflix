class User {
  final String id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id' : String id,
        'email' : String email,
        'password' : String password,
        'first_name' : String firstName,
        'last_name' : String lastName,
        'role' : String role,
      } => 
        User(
          id : id,
          email : email,
          password : password,
          firstName: firstName,
          lastName: lastName,
          role: role,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}
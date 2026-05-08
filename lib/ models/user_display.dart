import 'user_dto.dart';

// Domain model — shaped for UI, not API
class UserDisplay {
  final String displayName;    // "john doe" → "JOHN DOE"
  final String email;
  final String location;       // Derived: "123 Main St, Springfield"
  final String bio;
  final int postCount;         // Derived: posts.length
  final List<String> postTitles;

  UserDisplay({
    required this.displayName,
    required this.email,
    required this.location,
    required this.bio,
    required this.postCount,
    required this.postTitles,
  });

  // Transform DTO → UI model
  factory UserDisplay.fromDTO(UserDTO dto) => UserDisplay(
    displayName: dto.name.toUpperCase(),
    email: dto.email,
    location: dto.address != null
        ? '${dto.address!.street}, ${dto.address!.city}'
        : 'No location',
    bio: dto.profile.bio,
    postCount: dto.posts.length,
    postTitles: dto.posts.map((p) => p.title).toList(),
  );
}

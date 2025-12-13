class AppConstants {
  static const basePath = "Omar/#";
  // Collections
  static const String usersCollection = '$basePath/users';
  static const String chatsCollection = '$basePath/chats';
  static const String messagesCollection = '$basePath/messages';
  static const String groupsCollection = '$basePath/groups';
  static const String storiesCollection = '$basePath/stories';

  // Storage paths
  static const String profileImagesPath = '$basePath/profile_images';
  static const String messageImagesPath = '$basePath/messages';
  static const String groupImagesPath = '$basePath/groups';
  static const String storiesPath = '$basePath/stories';

  // Story expiration
  static const Duration storyExpirationDuration = Duration(hours: 24);
}

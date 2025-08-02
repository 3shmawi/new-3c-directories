String authCodeErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'The user account has been disabled.';
    case 'user-not-found':
      return 'No user found for the given email.';
    case 'wrong-password':
      return 'The password is incorrect.';
    case 'weak-password':
      return 'The password is too weak.';
    case 'email-already-in-use':
      return 'The email address is already in use by another account.';
    case 'invalid-credential':
      return 'The credential is invalid or has expired.';
    case 'requires-recent-login':
      return 'This operation requires recent authentication. Please log in again.';
    default:
      return 'An unknown error occurred.';
  }
}

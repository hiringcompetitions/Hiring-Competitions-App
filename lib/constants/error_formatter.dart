import 'package:firebase_auth/firebase_auth.dart';

class ErrorFormatter {
  String formatAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return formatFirebaseAuthError(error);
    } else if(error is Exception) {
      final message = error.toString();
      if(message.contains("Exception")) {
        message.replaceAll("Exception : ", '');
      }
      return 'An error Occured. Please Try again';
    } else {
      return 'Unknown error Occured. Please try again';
    }
  }

  String formatFirebaseAuthError(dynamic error) {
    String errorMessage = 'An unknown error occurred. Please try again.';

    switch (error.code) {
      case 'invalid-credential':
        errorMessage = 'Invalid Credentials';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'user-disabled':
        errorMessage = 'This user account has been disabled.';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again.';
        break;
      case 'email-already-in-use':
        errorMessage = 'This email is already in use.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Email/password accounts are not enabled.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Please try again later.';
        break;
      case 'network-request-failed':
        errorMessage = 'Network error. Check your internet connection.';
        break;
      default:
        errorMessage = error.message ?? errorMessage;
    }
    return errorMessage;
  }

  String formatFirestoreError(dynamic error) {
    String errorMessage = 'An unknown Firestore error occurred.';

    if (error is FirebaseException && error.plugin == 'cloud_firestore') {
      switch (error.code) {
        case 'permission-denied':
          errorMessage = 'You don’t have permission to perform this action.';
          break;
        case 'unavailable':
          errorMessage = 'Firestore is currently unavailable. Please try again later.';
          break;
        case 'not-found':
          errorMessage = 'The requested document was not found.';
          break;
        case 'resource-exhausted':
          errorMessage = 'Quota exceeded. Try again later.';
          break;
        case 'aborted':
          errorMessage = 'The operation was aborted. Please retry.';
          break;
        case 'cancelled':
          errorMessage = 'The operation was cancelled.';
          break;
        case 'already-exists':
          errorMessage = 'A document with this ID already exists.';
          break;
        case 'deadline-exceeded':
          errorMessage = 'The request took too long to complete.';
          break;
        case 'data-loss':
          errorMessage = 'Unrecoverable data loss or corruption occurred.';
          break;
        case 'internal':
          errorMessage = 'An internal Firestore error occurred.';
          break;
        case 'invalid-argument':
          errorMessage = 'Invalid data provided to Firestore.';
          break;
        case 'unauthenticated':
          errorMessage = 'You must be signed in to perform this operation.';
          break;
        case 'failed-precondition':
          errorMessage = 'The operation failed due to a precondition not being met.';
          break;
        case 'out-of-range':
          errorMessage = 'An operation was attempted past the allowed range.';
          break;
        default:
          errorMessage = error.message ?? errorMessage;
      }
    }

    return errorMessage;
  }
}

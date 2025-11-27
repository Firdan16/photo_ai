import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

/// Helper class for converting exceptions to user-friendly messages
class ErrorHelper {
  /// Converts any error/exception to a user-friendly message string
  static String getUserFriendlyMessage(Object error) {
    if (error is SocketException) {
      return 'Please check your internet connection and try again.';
    }

    if (error is TimeoutException) {
      return 'The operation timed out. Please check your connection.';
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
        case 'unauthorized':
          return 'You don\'t have permission to perform this action.';
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'A server error occurred. Please try again later.';
      }
    }

    final message = error.toString().toLowerCase();

    if (message.contains('host lookup') ||
        message.contains('connection refused') ||
        message.contains('network is unreachable')) {
      return 'Please check your internet connection.';
    }

    if (message.contains('403') || message.contains('forbidden')) {
      return 'Access denied. Please contact support if this persists.';
    }

    if (message.contains('404') || message.contains('not found')) {
      return 'The requested resource was not found.';
    }

    if (message.contains('500') || message.contains('internal server error')) {
      return 'Our servers are having trouble. Please try again later.';
    }

    return 'Something went wrong. Please try again.';
  }
}

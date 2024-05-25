String formatTime(String inputTime) {
  DateTime dateTime = DateTime.parse(inputTime);
  String formattedTime =
      "${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}";
  return formattedTime;
}

String _addLeadingZero(int number) {
  return number.toString().padLeft(2, '0');
}

String getCommentTimeDifference(DateTime commentTime) {
  final now = DateTime.now();
  final difference = now.difference(commentTime);

  if (difference.inSeconds < 60) {
    return 'Just now'; // A second ago
  } else if (difference.inMinutes == 1) {
    return '1 minute ago'; // 1 minute ago
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago'; // Minutes ago
  } else if (difference.inHours == 1) {
    return '1 hour ago'; // 1 hour ago
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago'; // Hours ago
  } else if (difference.inDays == 1) {
    return '1 day ago'; // 1 day ago
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago'; // Days ago
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    if (weeks == 1) {
      return '1 week ago'; // 1 week ago
    } else {
      return '$weeks weeks ago'; // Weeks ago
    }
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    if (months == 1) {
      return '1 month ago'; // 1 month ago
    } else {
      return '$months months ago'; // Months ago
    }
  } else {
    final years = (difference.inDays / 365).floor();
    if (years == 1) {
      return '1 year ago'; // 1 year ago
    } else {
      return '$years years ago'; // Years ago
    }
  }
}

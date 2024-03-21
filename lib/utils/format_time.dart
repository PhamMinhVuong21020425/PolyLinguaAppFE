String formatTime(String inputTime) {
  DateTime dateTime = DateTime.parse(inputTime);
  String formattedTime =
      "${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}";
  return formattedTime;
}

String _addLeadingZero(int number) {
  return number.toString().padLeft(2, '0');
}

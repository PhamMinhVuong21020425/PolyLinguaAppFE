int calculateReadingTime(String content) {
  int words = content.split(' ').length;
  return (words / 90).ceil();
}

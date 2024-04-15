int calculateReadTime(String content) {
  int words = content.length;
  return (words / 60).ceil();
}

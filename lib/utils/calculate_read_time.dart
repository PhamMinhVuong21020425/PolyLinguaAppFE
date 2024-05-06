int calculateReadTimeJa(String content) {
  int words = content.length;
  return (words / 60).ceil();
}

int calculateReadTimeEn(String content) {
  int words = content.split(' ').length;
  return (words / 60).ceil();
}

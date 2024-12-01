class MenuData {
  final String path, title;
   final String ?router;
  final List<String>? unit;

  MenuData({
    required this.path,
    required this.title,
    this.router,
    this.unit
  });
}
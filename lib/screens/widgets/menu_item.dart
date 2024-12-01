class MenuItem {
  final String path, title; 
  final String ?router;
  final List<String>? unit;

  MenuItem(
      {required this.path,
      required this.title,
      this.router,
      this.unit});
}

class Service {
  final int id;
  final String url;
  final String name;
  final double pingThreshold;

  Service({
    required this.id,
    required this.url,
    required this.name,
    required this.pingThreshold,
  });
}

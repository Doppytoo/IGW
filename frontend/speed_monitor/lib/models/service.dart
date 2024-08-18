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

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        url: json['url'],
        name: json['name'],
        pingThreshold: json['ping_threshold'],
      );
}

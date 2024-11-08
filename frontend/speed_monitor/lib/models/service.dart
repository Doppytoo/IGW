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

  Service.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          url: json['url'],
          name: json['name'],
          pingThreshold: json['ping_threshold'],
        );

  Map<String, Object> toJson() => {
        'id': id,
        'url': url,
        'name': name,
        'ping_threshold': pingThreshold,
      };

  Service copyWith({
    int? id,
    String? url,
    String? name,
    double? pingThreshold,
  }) =>
      Service(
        id: id ?? this.id,
        url: url ?? this.url,
        name: name ?? this.name,
        pingThreshold: pingThreshold ?? this.pingThreshold,
      );
}

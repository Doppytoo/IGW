import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';

class SpeedMonitorApiClient_O {
  final String baseUrl;
  String authToken;

  SpeedMonitorApiClient_O(this.baseUrl, this.authToken);

  Future<http.Response> _apiGet(Uri url) async {
    return await http.get(url, headers: {'Bearer': authToken});
  }

  Future<http.Response> _apiPost(Uri url, String body) async {
    return await http.post(url,
        body: body,
        headers: {'Bearer': authToken, 'Content-Type': 'application/json'});
  }

  Future<http.Response> _apiPatch(Uri url, String body) async {
    return await http.patch(url,
        body: body,
        headers: {'Bearer': authToken, 'Content-Type': 'application/json'});
  }

  Future<bool> ping() async {
    final url = Uri.http(baseUrl, '/ping');
    final resp = await http.get(url);

    return (resp.statusCode == 200);
  }

  Future<List<Incident>> getIncidients({
    int page = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final url = Uri.http(baseUrl, '/incidents', {
      'page': page,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });
    final resp = await _apiGet(url);

    return (json.decode(resp.body) as List<Map<String, dynamic>>)
        .map((incidentJson) => Incident.fromJson(incidentJson))
        .toList();
  }

  Future<List<SpeedRecord>> getRecords({
    int page = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final url = Uri.http(baseUrl, '/records', {
      'page': page,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });
    final resp = await _apiGet(url);

    // return json.decode(resp.body);

    final records = (json.decode(resp.body) as List<Map<String, dynamic>>)
        .map((recordJson) => SpeedRecord.fromJson(recordJson))
        .toList();

    return records;
  }

  Future<List<Service>> getServices() async {
    final url = Uri.http(baseUrl, '/services/all');
    final resp = await _apiGet(url);

    return (json.decode(resp.body) as List<Map<String, dynamic>>)
        .map((serviceJson) => Service.fromJson(serviceJson))
        .toList();
  }

  Future<bool> addService(Map<String, dynamic> serviceJson) async {
    final url = Uri.http(baseUrl, '/services/new');
    final resp = await _apiPost(url, json.encode(serviceJson));

    return (resp.statusCode == 200);
  }
}

// To parse this JSON data, do
//
//     final package = packageFromJson(jsonString);

import 'dart:convert';

List<Package> packageFromJson(String str) =>
    List<Package>.from(json.decode(str).map((x) => Package.fromJson(x)));

String packageToJson(List<Package> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Package {
  Package({
    required this.name,
    required this.version,
    required this.description,
    required this.url,
    required this.changelogUrl,
    required this.grantedPoints,
    required this.maxPoints,
    required this.likeCount,
    required this.popularityScore,
    required this.lastUpdated,
  });

  final String name;
  final String version;
  final String description;
  final String url;
  final String changelogUrl;
  final String grantedPoints;
  final String maxPoints;
  final String likeCount;
  final String popularityScore;
  final DateTime lastUpdated;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        name: json["name"],
        version: json["version"],
        description: json["description"],
        url: json["url"],
        changelogUrl: json["changelogUrl"],
        grantedPoints: json["grantedPoints"],
        maxPoints: json["maxPoints"],
        likeCount: json["likeCount"],
        popularityScore: json["popularityScore"],
        lastUpdated: DateTime.parse(json["lastUpdated"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
        "description": description,
        "url": url,
        "changelogUrl": changelogUrl,
        "grantedPoints": grantedPoints,
        "maxPoints": maxPoints,
        "likeCount": likeCount,
        "popularityScore": popularityScore,
        "lastUpdated": lastUpdated.toIso8601String(),
      };
}

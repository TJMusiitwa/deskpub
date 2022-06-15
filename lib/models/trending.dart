// To parse this JSON data, do
//
//     final trending = trendingFromJson(jsonString);

import 'dart:convert';

List<Trending> trendingFromJson(String str) =>
    List<Trending>.from(json.decode(str).map((x) => Trending.fromJson(x)));

String trendingToJson(List<Trending> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trending {
  Trending({
    required this.owner,
    required this.repoName,
    required this.description,
    required this.totalStars,
    this.starsSince,
    required this.totalForks,
    required this.topContributors,
  });

  final String owner;
  final String repoName;
  final String description;
  final int totalStars;
  final String? starsSince;
  final int totalForks;
  final List<TopContributor> topContributors;

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
        owner: json["owner"],
        repoName: json["repoName"],
        description: json["description"],
        totalStars: json["totalStars"],
        starsSince: json["starsSince"],
        totalForks: json["totalForks"],
        topContributors: List<TopContributor>.from(
            json["topContributors"].map((x) => TopContributor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "repoName": repoName,
        "description": description,
        "totalStars": totalStars,
        "starsSince": starsSince,
        "totalForks": totalForks,
        "topContributors":
            List<dynamic>.from(topContributors.map((x) => x.toJson())),
      };
}

class TopContributor {
  TopContributor({
    required this.name,
    required this.avatar,
  });

  final String name;
  final String avatar;

  factory TopContributor.fromJson(Map<String, dynamic> json) => TopContributor(
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatar": avatar,
      };
}

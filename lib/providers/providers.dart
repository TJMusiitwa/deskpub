import 'dart:developer';

import 'package:deskpub/models/trending.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:pub_api_client/pub_api_client.dart';

final pubClientProvider = Provider.autoDispose<PubClient>((ref) => PubClient());
final githubClientProvider = Provider.autoDispose<GitHub>((ref) => GitHub());

final flutterFavouritesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final client = ref.watch(pubClientProvider);
  ref.keepAlive();
  //ref.onDispose(() => client.close());
  return await client.fetchFlutterFavorites();
});

final firebasePackagesProvider =
    FutureProvider.autoDispose<List<PackageResult>>((ref) async {
  final client = ref.watch(pubClientProvider);
  ref.onDispose(() => client.close());
  return await client.fetchPublisherPackages('firebase.google.com');
});

final googlePackagesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final client = ref.watch(pubClientProvider);
  ref.keepAlive();
  ref.onDispose(() => client.close());
  return await client.fetchGooglePackages();
});

final todayTrendingProvider =
    FutureProvider.autoDispose<List<Trending>>((ref) async {
  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/today.json'));
  ref.keepAlive();

  final trending = trendingFromJson(response.body);
  return trending;
});

final weekTrendingProvider =
    FutureProvider.autoDispose<List<Trending>>((ref) async {
  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/week.json'));
  ref.keepAlive();

  final trending = trendingFromJson(response.body);
  return trending;
});

final monthTrendingProvider = FutureProvider<List<Trending>>((ref) async {
  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/month.json'));

  final trending = trendingFromJson(response.body);
  return trending;
});

final singlePackageProvider = FutureProvider.autoDispose
    .family<PubPackage, String>((ref, packageName) async {
  final client = ref.watch(pubClientProvider);
  //ref.onDispose(() => client.close());
  return await client.packageInfo(packageName);
});

final scorePackageProvider = FutureProvider.autoDispose
    .family<PackageScore, String>((ref, packageName) async {
  final client = ref.watch(pubClientProvider);
  //ref.onDispose(() => client.close());
  return await client.packageScore(packageName);
});

final metricsPackageProvider = FutureProvider.autoDispose
    .family<PackageMetrics?, String>((ref, packageName) async {
  final client = ref.watch(pubClientProvider);
  //ref.onDispose(() => client.close());
  return await client.packageMetrics(packageName);
});

final packageReadmeProvider =
    FutureProvider.autoDispose.family<String, String>((ref, packageName) async {
  final client = ref.watch(pubClientProvider);
  final githubClient = ref.watch(githubClientProvider);
  final packageInfo = client.packageInfo(packageName);
  final repositoryUrl = await packageInfo.then((value) {
    if (value.latestPubspec.unParsedYaml!['repository'] != null) {
      return value.latestPubspec.unParsedYaml!['repository'].toString();
    } else if (value.latestPubspec.homepage != null) {
      return value.latestPubspec.homepage!;
    } else {
      return 'Nothing here';
    }
  });

  final readme = githubClient.repositories.getReadme(
      RepositorySlug(repositoryUrl.split('/')[3], repositoryUrl.split('/')[4]));

  log('Repository URL: $repositoryUrl');

  //log(RepositorySlug('flutterfire', repositoryUrl.split('/').last));

  log(RepositorySlug(repositoryUrl.split('/')[3], repositoryUrl.split('/')[4])
      .toString());

  ref.keepAlive();

  return readme.then((value) => value.text);
});

final packagePublisherProvider = FutureProvider.autoDispose
    .family<PackagePublisher, String>((ref, packageName) async {
  return await ref.watch(pubClientProvider).packagePublisher(packageName);
});

final searchPackagesProvider = FutureProvider.autoDispose.family<
    List<PackageResult>,
    ({
      String searchQuery,
      int? page,
      SearchOrder? order,
    })>((ref, searchOptions) async {
  final client = ref.watch(pubClientProvider);

  final searchResults = await client.search(searchOptions.searchQuery,
      page: searchOptions.page ?? 1,
      sort: searchOptions.order ?? SearchOrder.top);

  ref.keepAlive();

  return searchResults.packages;
});

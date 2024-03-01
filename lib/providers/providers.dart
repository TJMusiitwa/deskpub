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
  var request = http.Request(
      'GET', Uri.parse('http://api.flutter.space/v1/trending/today.json'));

  //http.StreamedResponse response = await request.send();

  http.Response response = await http
      .get(Uri.parse('http://api.flutter.space/v1/trending/today.json'));

  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  // } else {
  //   print(response.reasonPhrase);
  // }
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

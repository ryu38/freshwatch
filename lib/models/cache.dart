import 'package:async/async.dart';

class Cache {

  final imgUrls = <String, AsyncMemoizer<String>>{};
}
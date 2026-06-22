import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:zingo/constants/cache_keys.dart';

class AudioCacheService {
  static const key = CacheKeys.dialogAudio;
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );

  static Future<File> getFileOrDownload(String url) async {
    try {
      final file = await instance.getFileFromCache(key);
      print(file.toString());
      final fileInfo = await instance.getSingleFile(url);
      return fileInfo;
    } catch (e) {
      throw Exception(e);
    }
  }
}

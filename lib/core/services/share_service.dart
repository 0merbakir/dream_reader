import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_service.g.dart';

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) {
  return ShareService();
}

class ShareService {
  Future<void> captureAndShare(GlobalKey key,
      {String text = "Check out my dream from DreamReader!"}) async {
    try {
      // 1. Locate the RenderRepaintBoundary
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("❌ ShareService: Boundary not found.");
        return;
      }

      // 2. Convert to Image
      // Pixel ratio of 3.0 for high resolution
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      // 3. Save to Temp File
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/dream_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      // 4. Trigger Share
      await Share.shareXFiles([XFile(path)], text: text);
    } catch (e) {
      debugPrint("❌ ShareService Error: $e");
    }
  }
}

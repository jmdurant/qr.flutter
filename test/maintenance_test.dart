import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('directional padding resolves for $direction', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: Center(
            child: QrImageView(
              data: 'padding-test',
              size: 200,
              padding: EdgeInsetsDirectional.fromSTEB(10, 12, 30, 14),
            ),
          ),
        ),
      );
      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(QrImageView),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(
        padding.padding.resolve(direction),
        direction == TextDirection.ltr
            ? const EdgeInsets.fromLTRB(10, 12, 30, 14)
            : const EdgeInsets.fromLTRB(30, 12, 10, 14),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('pairing payload renders at supported sizes and densities', (
    tester,
  ) async {
    final payload = jsonEncode({
      'type': 'vr_pairing',
      'code': '123456',
      'url': 'https://clinic.example.invalid',
      'pairingSecret': 'synthetic-secret-for-decoding-tests-only',
    });
    final output = Platform.environment['QR_TEST_OUTPUT_DIR'];
    for (final size in [150.0, 240.0, 300.0]) {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: RepaintBoundary(
              key: key,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: payload,
                  size: size,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      for (final ratio in [1.0, 2.0, 3.0]) {
        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: ratio);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          expect(png, isNotNull);
          if (output != null) {
            await File(
              '$output/pairing-${size.toInt()}-${ratio.toInt()}.png',
            ).writeAsBytes(png!.buffer.asUint8List());
            await File('$output/expected.txt').writeAsString(payload);
          }
          image.dispose();
        });
      }
    }
  });
}

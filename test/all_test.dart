/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */
import 'package:flutter_test/flutter_test.dart';

import 'image_test.dart' as image;
import 'painter_test.dart' as painter;
import 'validator_test.dart' as validator;
import 'maintenance_test.dart' as maintenance;

void main() {
  group('image:', image.main);
  group('painter:', painter.main);
  group('validator:', validator.main);
  group('maintenance:', maintenance.main);
}

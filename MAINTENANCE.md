# QR Flutter maintenance fork

Owned repository: https://github.com/jmdurant/qr.flutter
Upstream: https://github.com/theyakka/qr.flutter

Purpose: keep the existing widget usable with current stable Flutter and qr 4,
without adding unrelated styling or replacing the encoder. Preserve upstream
copyright, BSD-3-Clause license and contributor attribution.

Adopted patches (cherry-picked with original authors and commit references):
- #236 / 79e3f4e: qr 4 migration, typed correction levels, validation tests.
- #231 / c1dbef9: EdgeInsetsGeometry, enabling directional padding.
- #220 / ce340db: remove the embedded-image debug print.

Not adopted: painter padding #228 (canvas/repaint/size concerns), module-rounding
#144/#215 (needs separate sizing evidence), or optional styling/logo features.

## Validation

Use current Flutter stable, not an exact SDK release pin:

```sh
flutter pub get
flutter test test/all_test.dart
# Python environment with Pillow and zxing-cpp (tested with zxing-cpp 2.3.0):
python tool/check_pairing_decode.py
```

The latter renders a synthetic Quest pairing payload at 150/240/300 logical
pixels and device ratios 1/2/3, then independently decodes all nine PNGs with
ZXing and compares exact payloads. No credentials or real pairing secrets are
used. Directional padding is checked in both text directions.

On Flutter 3.47.9, four inherited styling goldens differed from their older
reference images. Running untouched upstream d5e7206 reproduced exactly the
same four failures. Baseline and patched rendered RGBA bytes were identical in
all four cases. References were refreshed only after that comparison; no painter
geometry or rounding changes were made. Plain QR, logo and painter goldens passed
without refreshing. Hardware-camera acceptance is not claimed by these tests.

## App integration

The OpenEMR app vendors the reviewed lib/test/tool and license files under
packages/qr_flutter, with the fork commit recorded in UPSTREAM.md. This keeps
normal app builds offline/reproducible and within the existing repository-local
package policy. To update, review fork commits, replace the vendored copy and
record its commit, resolve the app lock, and rerun fork, decoding, app pairing
and Customizer profile tests. Do not edit the vendored implementation alone.

Monitor upstream for an official maintained release. Return to it when it
contains the required compatibility fixes and passes the same tests.

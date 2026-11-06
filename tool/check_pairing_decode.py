#!/usr/bin/env python3
"""Render with Flutter, decode independently with ZXing; synthetic payload only.
Requires Flutter on PATH and Python packages zxing-cpp and Pillow.
"""
import os
from pathlib import Path
import subprocess
import tempfile

from PIL import Image
import zxingcpp

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='qr-pairing-') as temporary:
    subprocess.run(['flutter', 'test', '--reporter', 'expanded',
                    'test/maintenance_test.dart'], cwd=root, check=True,
                   env={**os.environ, 'QR_TEST_OUTPUT_DIR': temporary})
    output = Path(temporary)
    expected = (output / 'expected.txt').read_text()
    images = list(output.glob('pairing-*.png'))
    assert len(images) == 9, f'Expected 9 rendered fixtures, got {len(images)}'
    for file in images:
        with Image.open(file) as image:
            result = zxingcpp.read_barcode(image)
        assert result is not None and result.text == expected, file.name
    print('PASS: 9 pairing QR images independently decoded to the exact payload')

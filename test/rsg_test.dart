// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random_string_generator.dart';

final Logger _log = new Logger('rsg_test.dart', watermark: Severity.info);

/// The number of random numbers each test is run on.
int count = 1000;

/// The seed for the RSG.
int seed = 1;

/// A Random String Generator
RSG rsg = new RSG(seed);

void main() {

  rsgISTest();
  rsgDSTest();

}

/// Test DICOM IS values.
void rsgISTest() {
  test('Random IS Test', () {
    for (int i = 0; i < count; i++) {
      var s = (rsg.isString);
      if (s.length > 12) throw '"$s".length = ${s.length}';
      if (s.length == 1) _log.debug('***  IS: "$s".length = ${s.length}');
      if (s.length == 12) _log.debug1('*** IS: "$s".length = ${s.length}');
      _log.debug1(' IS: ${s.length}: "$s"');
      expect(s.length <= 12, true);
      //TODO: add error handler to int.parse
      int x = int.parse(s);
      expect(x is int, true);
    }
  });
}

/// Test DICOM DS values.
void rsgDSTest() {
  group('Generate Random Decimal Strings', () {

    test('Random DS Fixed Point Test', () {
      for (int i = 0; i < count; i++) {
        var s = (rsg.getFixedDSString(14));
        var len = s.length.toString().padLeft(2, ' ');
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length < 8) _log.debug('*** FDS $len: "$s".length');
        if (s.length > 14) _log.debug('*** FDS $len: "$s".length');
        _log.debug1('    FDS $len: "$s"');
        expect(s.length <= 16, true);
        double x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Exponential Test', () {
      for (int i = 0; i < count; i++) {
        var s = (rsg.getExpoDSString(13));
        var len = s.length.toString().padLeft(2, ' ');
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length == 8) _log.debug('*** EDS $len: "$s".length');
        if (s.length == 16) _log.debug('*** EDS $len: "$s".length');
        _log.debug1('    EDS $len: "$s"');
        expect(s.length <= 16, true);
        double x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Precision Test', () {
      for (int i = 0; i < count; i++) {
        var s = (rsg.getPrecisionDSString());
        var len = s.length.toString().padLeft(2, ' ');
        RangeError.checkValueInInterval(s.length, 1, 16, "String too Long");
        _log.debug1('    PDS $len: "$s"');
        expect(s.length <= 16, true);
        double x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('increasing DS Precision Test', () {
      var limit = count ~/ 16;
      for (int i = 0; i < limit; i++) {
        for (int j = 1; j < 16; j++) {
          var s = (rsg.getPrecisionDSString(j));
          var len = s.length.toString().padLeft(2, ' ');
          var p = j.toString().padLeft(2, ' ');
          if (s.length > 16) throw '"$s".length = ${s.length}';
          if (s.length < 8) _log.debug('*** $p PDS $len: "$s".length');
          if (s.length == 16) _log.debug1('*** $p PDS $len: "$s".length');
          _log.debug1('   $p PDS $len: "$s"');
          expect(s.length <= 16, true);
          double x = double.parse(s);
          expect(x is double, true);
        }
      }
    });

    test('Random DS String Test', () {
      for (int i = 0; i < count; i++) {
        var s = (rsg.getDSString());
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length < 5) _log.debug('*** RDS: "$s".length = ${s.length}');
        if (s.length == 16) _log.debug1('*** RDS: "$s".length = ${s.length}');
        _log.debug1('    RDS: ${s.length}: "$s"');
        expect(s.length <= 16, true);
        double x = double.parse(s);
        expect(x is double, true);
      }
    });

  });
}


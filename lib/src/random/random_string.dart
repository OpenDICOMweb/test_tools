// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:math';
import 'package:common/common.dart';

String randomString(int length,
    {bool noLowerCase = true,
    bool noCharacter = false,
    bool noNumber = false,
    bool noSpecialCharacter = false,
    bool isDecimal = false}) {
  var rand = new Random();
  bool dotOne = false, keKEOne = false;
  int prevCode, plusMinusCount = 0, iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(122);
    while (!((!noCharacter && alpha >= ka && alpha <= kz && !noLowerCase) ||
        (!noCharacter && alpha >= kA && alpha <= kZ) ||
        (!noNumber && alpha >= k0 && alpha <= k9) ||
        (!noSpecialCharacter &&
            (alpha == kSpace || alpha == kUnderscore))) ||
        isDecimal) {
      iterations++;
      if (iterations > 500) break;
      if (isDecimal &&
          ((alpha >= k0 && alpha <= k9) ||
              (alpha == kDot ||
                  alpha == kE ||
                  alpha == ke ||
                  alpha == kPlusSign ||
                  alpha == kMinusSign))) {
        //if ((alpha == kPlusSign || alpha == kMinusSign) && (prevCode == null || prevCode == null)){
        //
        // }
        if ((index == length - 1) &&
            (alpha == kE ||
                alpha == ke ||
                alpha == kPlusSign ||
                alpha == kMinusSign)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == null && alpha == kE || alpha == ke) ||
            (prevCode == ke ||
                prevCode == kE &&
                    (alpha >= k0 && alpha <= k9 || alpha == kDot))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == kE || prevCode == ke || prevCode == null) &&
            (alpha == kPlusSign || alpha == kMinusSign) &&
            plusMinusCount < 3) {
          plusMinusCount++;
          prevCode = alpha;
          break;
        }

        if ((alpha == kPlusSign || alpha == kMinusSign) &&
            (prevCode == kDot ||
                (prevCode >= k0 && prevCode <= k9) ||
                prevCode == kMinusSign ||
                prevCode == kPlusSign)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((alpha == kMinusSign ||
            alpha == kPlusSign ||
            alpha == ke ||
            alpha == kE) &&
            (prevCode == kMinusSign ||
                prevCode == kPlusSign ||
                prevCode == kDot)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == kPlusSign || prevCode == kMinusSign) &&
            alpha >= k0 &&
            alpha <= k9) {
          prevCode = alpha;
          break;
        }

        if ((dotOne && alpha == kDot) ||
            (keKEOne && (alpha == ke || alpha == kE)) ||
            (plusMinusCount > 2 &&
                (alpha == kPlusSign || alpha == kMinusSign))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if (!dotOne && alpha == kDot) {
          dotOne = true;
          prevCode = alpha;
        }

        if (!keKEOne && (alpha == ke || alpha == kE)) {
          keKEOne = true;
          prevCode = alpha;
        }

        if (alpha >= k0 && alpha <= k9) {
          prevCode = alpha;
          break;
        }

        break;
      } else
        alpha = rand.nextInt(122);
    }
    return alpha;
  });

  return new String.fromCharCodes(codeUnits);
}


//Generates DICOM String characters
//Visible ASCII characters, except Backslash.
String generateDcmChar(int length) {
  var rand = new Random();
  int iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while (!(alpha >= kSpace && alpha < kDelete && alpha != kBackslash)) {
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return new String.fromCharCodes(codeUnits);
}

//Generates DICOM Text characters. All visible ASCII characters
//are legal including Backslash.
String generateTextChar(int length) {
  var rand = new Random();
  int iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while ((alpha < kSpace || alpha == kDelete)) {
      /*iterations++;
      if (iterations > 500) break;*/
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return new String.fromCharCodes(codeUnits);
}

//Generates DICOM Code String(CS) characters.
//Visible ASCII characters, except Backslash.
String generateCodeStringChar(int length) {
  var rand = new Random();
  int iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while (!(isUppercaseChar(alpha) ||
        isDigitChar(alpha) ||
        alpha == kSpace ||
        alpha == kUnderscore)) {
      iterations++;
      if (iterations > 500) break;
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return new String.fromCharCodes(codeUnits);
}

//Generates Person name with desired no of groups [noOfgroups],
//no of components [noOfComponents] and length of components [componentLen]
String generatePersonName(
    int noOfgroups, int noOfComponents, int componentLen) {
  List<String> listGroup = <String>[];
  for (int i = 0; i < noOfgroups; i++) {
    List<String> listComponent = <String>[];
    for (int j = 0; j < noOfComponents; j++) {
      var rand = new Random();
      int iterations = 0;
      var codeUnits = new List.generate(componentLen, (index) {
        var alpha = rand.nextInt(127);
        while (!(alpha >= kSpace && alpha < kDelete && alpha != kBackslash && alpha != kCircumflex && alpha != kEqual)) {
          alpha = rand.nextInt(126);
        }
        return alpha;
      });
      listComponent.add(new String.fromCharCodes(codeUnits));
    }
    listGroup.add(listComponent.join("^"));
  }
  return listGroup.join("=");
}
import 'package:flutter/services.dart';

class _Separator {
  String value;
  int indexInMask;
  _Separator({
    required this.value,
    required this.indexInMask,
  });
}

class MaskedInputFormatter extends TextInputFormatter {
  final String mask;

  final String _anyCharMask = '#';
  final String _onlyDigitMask = '0';
  final RegExp? allowedCharMatcher;
  final List<_Separator> _separators = [];

  String _maskedValue = '';

  MaskedInputFormatter(
    this.mask, {
    this.allowedCharMatcher,
  });

  bool get isFilled => _maskedValue.length == mask.length;

  String get unmaskedValue {
    _prepareMask();
    final stringBuffer = StringBuffer();
    for (var i = 0; i < _maskedValue.length; i++) {
      var char = _maskedValue[i];
      if (!_separators.any((s) => s.value == char)) {
        stringBuffer.write(char);
      }
    }
    return stringBuffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final FormattedValue oldFormattedValue = applyMask(
      oldValue.text,
    );
    final FormattedValue newFormattedValue = applyMask(
      newValue.text,
    );
    var numSeparatorsInNew = 0;
    var numSeparatorsInOld = 0;

    /// it's only used in CreditCardExpirationDateFormatter
    /// when it adds a leading zero to the input
    var addOffset = newFormattedValue._numLeadingSymbols;
    numSeparatorsInOld = _countSeparators(
      oldFormattedValue.text,
    );
    numSeparatorsInNew = _countSeparators(
      newFormattedValue.text,
    );

    var separatorsDiff = (numSeparatorsInNew - numSeparatorsInOld);
    if (newFormattedValue._isErasing) {
      separatorsDiff = 0;
    }
    var selectionOffset = newValue.selection.end + separatorsDiff;
    _maskedValue = newFormattedValue.text;

    if (selectionOffset > _maskedValue.length) {
      selectionOffset = _maskedValue.length;
    }

    return TextEditingValue(
      text: _maskedValue,
      selection: TextSelection.collapsed(
        offset: selectionOffset + addOffset,
        affinity: TextAffinity.upstream,
      ),
    );
  }

  bool _isMatchingRestrictor(String character) {
    if (allowedCharMatcher == null) {
      return true;
    }
    return allowedCharMatcher!.stringMatch(character) != null;
  }

  void _prepareMask() {
    if (_separators.isEmpty) {
      for (var i = 0; i < mask.length; i++) {
        final separatorChar = mask[i];
        if (separatorChar != _anyCharMask && separatorChar != _onlyDigitMask) {
          _separators.add(
            _Separator(
              value: separatorChar,
              indexInMask: i,
            ),
          );
        }
      }
    }
  }

  int _countSeparators(String text) {
    _prepareMask();
    var numSeparators = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];

      if (_separators.any((s) => s.value == char)) {
        numSeparators++;
      }
    }
    return numSeparators;
  }

  String _removeSeparators(String text) {
    var stringBuffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      var char = text[i];
      if (!_separators.any((s) => s.value == char)) {
        stringBuffer.write(char);
      }
    }
    return stringBuffer.toString();
  }

  _Separator? _getSeparatorForIndex(int index) {
    try {
      return _separators.firstWhere(
        (s) => s.indexInMask == index,
      );
    } catch (e) {
      return null;
    }
  }

  FormattedValue applyMask(String text) {
    _prepareMask();
    String clearedValueAfter = _removeSeparators(text);
    final isErasing = _maskedValue.length > text.length;
    FormattedValue formattedValue = FormattedValue();
    StringBuffer stringBuffer = StringBuffer();
    var index = 0;
    final splitMask = mask.split('');
    final placeholder = List.filled(
      splitMask.length,
      '',
      growable: false,
    );
    var lastRealCharIndex = 0;
    for (var i = 0; i < splitMask.length; i++) {
      final separator = _getSeparatorForIndex(i);
      if (separator == null) {
        if (clearedValueAfter.length > index) {
          final maskOnDigitMatcher = splitMask[i] == _onlyDigitMask;
          var curChar = clearedValueAfter[index];
          if (maskOnDigitMatcher) {
            if (!isDigit(curChar)) {
              break;
            }
          } else {
            if (!_isMatchingRestrictor(curChar)) {
              break;
            }
          }
          placeholder[i] = curChar;
          lastRealCharIndex = i + 1;
          index++;
        } else {
          break;
        }
      } else {
        placeholder[i] = separator.value;
      }
    }
    for (var i = 0; i < lastRealCharIndex; i++) {
      stringBuffer.write(placeholder[i]);
    }
    formattedValue._isErasing = isErasing;
    formattedValue._formattedValue = stringBuffer.toString();

    return formattedValue;
  }

  bool isDigit(String? character) {
    if (character == null || character.isEmpty || character.length > 1) {
      return false;
    }
    return _digitRegExp.stringMatch(character) != null;
  }

  final RegExp _digitRegExp = RegExp(r'[-0-9]+');
}

class FormattedValue {
  String _formattedValue = '';
  bool _isErasing = false;
  int _numLeadingSymbols = 0;

  String get text {
    return _formattedValue;
  }

  /// Used in CreditCardExpirationInputFormatter
  /// to be able to add a leading zero
  void increaseNumberOfLeadingSymbols() {
    _numLeadingSymbols++;
  }

  @override
  String toString() {
    return _formattedValue;
  }
}

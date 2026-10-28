/// Holds calculator input and performs chained arithmetic operations.
class CalculatorLogic {
  String _currentInput = '0';
  double? _accumulator;
  String? _pendingOperator;
  String _expressionPrefix = '';
  String? _completedExpression;
  bool _startNewEntry = false;
  bool _hasError = false;

  String get currentInput => _currentInput;

  String get expressionDisplay {
    if (_hasError) return 'Error';
    final completedExpression = _completedExpression;
    if (completedExpression != null) return completedExpression;

    final expression = _expressionPrefix;
    if (expression.isEmpty) return _currentInput;
    return _startNewEntry ? expression : '$expression $_currentInput';
  }

  String get resultDisplay {
    if (_hasError) return 'Error';
    return _completedExpression == null ? '' : _currentInput;
  }

  void inputDigit(String digit) {
    if (_hasError) clear();
    _clearCompletedExpression();
    if (_startNewEntry) {
      _currentInput = '0';
      _startNewEntry = false;
    }

    if (_currentInput == '0') {
      _currentInput = digit;
    } else if (_currentInput == '-0') {
      _currentInput = '-$digit';
    } else {
      _currentInput += digit;
    }
  }

  void inputDecimal() {
    if (_hasError) clear();
    _clearCompletedExpression();
    if (_startNewEntry) {
      _currentInput = '0';
      _startNewEntry = false;
    }
    if (!_currentInput.contains('.')) {
      _currentInput += '.';
    }
  }

  void chooseOperator(String operator) {
    if (_hasError) return;
    _clearCompletedExpression();

    final accumulator = _accumulator;
    final enteredInput = _currentInput;
    if (accumulator != null && _pendingOperator != null && !_startNewEntry) {
      final result = _calculate(
        accumulator,
        double.parse(enteredInput),
        _pendingOperator!,
      );
      if (result == null) {
        _setError();
        return;
      }
      _accumulator = result;
      _currentInput = _formatNumber(result);
      _expressionPrefix = '$_expressionPrefix $enteredInput $operator';
    } else if (accumulator == null) {
      _accumulator = double.parse(_currentInput);
      _expressionPrefix = '$_currentInput $operator';
    } else if (_startNewEntry) {
      _expressionPrefix =
          '${_expressionPrefix.substring(0, _expressionPrefix.length - 1)}$operator';
    }

    _pendingOperator = operator;
    _startNewEntry = true;
  }

  void calculate() {
    final accumulator = _accumulator;
    final operator = _pendingOperator;
    if (_hasError || accumulator == null || operator == null) return;

    final operand = _startNewEntry ? accumulator : double.parse(_currentInput);
    final result = _calculate(accumulator, operand, operator);
    if (result == null) {
      _setError();
      return;
    }

    final expressionOperand =
        _startNewEntry ? _formatNumber(operand) : _currentInput;
    _completedExpression = '$_expressionPrefix $expressionOperand =';
    _currentInput = _formatNumber(result);
    _accumulator = null;
    _pendingOperator = null;
    _startNewEntry = true;
  }

  void toggleSign() {
    if (_hasError) return;
    _clearCompletedExpression();
    if (_startNewEntry && _pendingOperator != null) {
      _currentInput = '0';
      _startNewEntry = false;
    }
    _currentInput = _currentInput.startsWith('-')
        ? _currentInput.substring(1)
        : '-$_currentInput';
  }

  void backspace() {
    if (_hasError) {
      clear();
      return;
    }
    _clearCompletedExpression();
    if (_startNewEntry && _pendingOperator != null) {
      _currentInput = '0';
      _startNewEntry = false;
      return;
    }
    _startNewEntry = false;

    if (_currentInput.length <= 1 ||
        (_currentInput.length == 2 && _currentInput.startsWith('-'))) {
      _currentInput = '0';
    } else {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      if (_currentInput == '-0') _currentInput = '0';
    }
  }

  void clear() {
    _currentInput = '0';
    _accumulator = null;
    _pendingOperator = null;
    _expressionPrefix = '';
    _completedExpression = null;
    _startNewEntry = false;
    _hasError = false;
  }

  void _clearCompletedExpression() {
    if (_completedExpression == null) return;
    _expressionPrefix = '';
    _completedExpression = null;
  }

  void _setError() {
    _currentInput = 'Error';
    _accumulator = null;
    _pendingOperator = null;
    _expressionPrefix = '';
    _completedExpression = null;
    _startNewEntry = true;
    _hasError = true;
  }

  double? _calculate(double left, double right, String operator) {
    if (operator == '÷' && right == 0) return null;

    final result = switch (operator) {
      '+' => left + right,
      '−' => left - right,
      '×' => left * right,
      '÷' => left / right,
      _ => double.nan,
    };
    return result.isFinite ? result : null;
  }

  String _formatNumber(double number) {
    if (number == 0) return '0';
    if (number.abs() >= 1e15) return number.toString();

    return number.toStringAsFixed(10).replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

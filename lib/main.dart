import 'package:flutter/material.dart';

import 'calculator_button.dart';
import 'calculator_logic.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6750A4);
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorLogic _calculator = CalculatorLogic();

  void _refresh(VoidCallback action) {
    setState(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight;
            if (landscape) {
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDisplay(constraints.maxWidth * 0.4),
                  ),
                  Expanded(flex: 3, child: _buildKeypad()),
                ],
              );
            }

            return Column(
              children: [
                Expanded(flex: 2, child: _buildDisplay(constraints.maxWidth)),
                Expanded(flex: 5, child: _buildKeypad()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisplay(double width) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.06, 16, width * 0.06, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _fitRight(_calculator.expressionDisplay, 42, colors.onSurfaceVariant),
          const SizedBox(height: 8),
          _fitRight(_calculator.resultDisplay, 64, colors.onSurface),
        ],
      ),
    );
  }

  Widget _fitRight(String text, double fontSize, Color color) {
    return SizedBox(
      height: fontSize * 1.25,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _keyRow([
          _key(
            'C',
            isAction: true,
            onPressed: () => _refresh(_calculator.clear),
          ),
          _key(
            '⌫',
            isAction: true,
            onPressed: () => _refresh(_calculator.backspace),
          ),
          _key(
            '±',
            isAction: true,
            onPressed: () => _refresh(_calculator.toggleSign),
          ),
          _key('÷', isOperator: true),
        ]),
        _keyRow([_key('7'), _key('8'), _key('9'), _key('×', isOperator: true)]),
        _keyRow([_key('4'), _key('5'), _key('6'), _key('−', isOperator: true)]),
        _keyRow([_key('1'), _key('2'), _key('3'), _key('+', isOperator: true)]),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CalculatorButton(
                  label: '0',
                  onPressed: () => _refresh(() => _calculator.inputDigit('0')),
                ),
              ),
              Expanded(
                child: CalculatorButton(
                  label: '.',
                  onPressed: () => _refresh(_calculator.inputDecimal),
                ),
              ),
              Expanded(
                child: CalculatorButton(
                  label: '=',
                  isOperator: true,
                  onPressed: () => _refresh(_calculator.calculate),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _keyRow(List<Widget> keys) {
    return Expanded(child: Row(children: keys));
  }

  Widget _key(
    String label, {
    bool isOperator = false,
    bool isAction = false,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: CalculatorButton(
        label: label,
        isOperator: isOperator,
        isAction: isAction,
        onPressed: onPressed ?? () => _onKey(label),
      ),
    );
  }

  void _onKey(String label) {
    _refresh(() {
      if ('0123456789'.contains(label)) {
        _calculator.inputDigit(label);
      } else {
        _calculator.chooseOperator(label);
      }
    });
  }
}

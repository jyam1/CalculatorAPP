import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
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
  late CalculatorLogic _calculatorLogic;

  @override
  void initState() {
    super.initState();
    _calculatorLogic = CalculatorLogic(updateUI);
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _calculatorLogic.getDisplayText(),
                    style: const TextStyle(
                      fontSize: 48,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                  width: value == Btn.btn0
                      ? screenSize.width / 2
                      : (screenSize.width / 4),
                  height: screenSize.width / 5,
                  child: _buildButton(value),
                ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: _calculatorLogic.getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () => _calculatorLogic.onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorLogic {
  late String _number1;
  late String _operand;
  late String _number2;
  late final Function _updateUI;

  CalculatorLogic(this._updateUI)
      : _number1 = "",
        _operand = "",
        _number2 = "";

  void onBtnTap(String value) {
    switch (value) {
      case Btn.delete:
        delete();
        break;
      case Btn.clear:
        clearAll();
        break;
      case Btn.percent:
        convertToPercentage();
        break;
      case Btn.equals:
        calculate();
        break;
      default:
        appendValue(value);
        break;
    }
  }

  void calculate() {
    if (_number1.isNotEmpty && _operand.isNotEmpty && _number2.isNotEmpty) {
      final double num1 = double.parse(_number1);
      final double num2 = double.parse(_number2);

      double result;
      if (_operand == Btn.add) {
        result = num1 + num2;
      } else if (_operand == Btn.subtract) {
        result = num1 - num2;
      } else if (_operand == Btn.multiply) {
        result = num1 * num2;
      } else if (_operand == Btn.divide) {
        result = num1 / num2;
      } else {
        return;
      }

      _number1 = formatResult(result);
      _operand = "";
      _number2 = "";
    }
    _updateUI();
  }

  String formatResult(double result) {
    String formattedResult = result.toStringAsPrecision(3);
    if (formattedResult.endsWith(".0")) {
      formattedResult = formattedResult.substring(0, formattedResult.length - 2);
    }
    return formattedResult;
  }

  void convertToPercentage() {
    if (_number1.isNotEmpty && _operand.isEmpty && _number2.isEmpty) {
      final double number = double.parse(_number1);
      _number1 = "${(number / 100)}";
      _updateUI();
    }
  }

  void clearAll() {
    _number1 = "";
    _operand = "";
    _number2 = "";
    _updateUI();
  }

  void delete() {
    if (_number2.isNotEmpty) {
      _number2 = _number2.substring(0, _number2.length - 1);
    } else if (_operand.isNotEmpty) {
      _operand = "";
    } else if (_number1.isNotEmpty) {
      _number1 = _number1.substring(0, _number1.length - 1);
    }
    _updateUI();
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (_operand.isNotEmpty && _number2.isNotEmpty) {
        calculate();
      }
      _operand = value;
    } else if (_number1.isEmpty || _operand.isEmpty) {
      if (value == Btn.dot && _number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (_number1.isEmpty || _number1 == Btn.btn0)) {
        value = "0.";
      }
      _number1 += value;
    } else if (_number2.isEmpty || _operand.isNotEmpty) {
      if (value == Btn.dot && _number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (_number2.isEmpty || _number2 == Btn.btn0)) {
        value = "0.";
      }
      _number2 += value;
    }
    _updateUI();
  }

  Color getBtnColor(String value) {
    return [Btn.delete, Btn.clear].contains(value)
        ? Colors.blueGrey
        : [Btn.percent, Btn.multiply, Btn.add, Btn.subtract, Btn.divide, Btn.equals].contains(value)
        ? Colors.orange
        : Colors.grey;
  }

  String getDisplayText() {
    return "$_number1$_operand$_number2".isEmpty ? "0" : "$_number1$_operand$_number2";
  }
}

class Btn {
  static const String delete = "DEL";
  static const String clear = "CLEAR";
  static const String percent = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String equals = "=";
  static const String dot = ".";

  static const String btn0 = "0";
  static const String btn1 = "1";
  static const String btn2 = "2";
  static const String btn3 = "3";
  static const String btn4 = "4";
  static const String btn5 = "5";
  static const String btn6 = "6";
  static const String btn7 = "7";
  static const String btn8 = "8";
  static const String btn9 = "9";

  static const List<String> buttonValues = [
    delete, clear, percent, multiply,
    btn7, btn8, btn9, divide,
    btn4, btn5, btn6, subtract,
    btn1, btn2, btn3, add,
    btn0, dot, equals,
  ];
}

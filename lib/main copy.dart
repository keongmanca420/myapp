import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _displayText = "0";
  String _expression = "";

  void _appendToExpression(String value) {
    setState(() {
      if (value == '=') {
        _calculateResult();
      } else if (value == 'C') {
        _clear();
      } else {
        if (_displayText == "0" && value != '.') {
          _displayText = value;
        } else {
          _displayText += value;
        }
        _expression += value;
      }
    });
  }

  void _clear() {
    setState(() {
      _displayText = "0";
      _expression = "";
    });
  }

  void _calculateResult() {
    try {
      final result = _evaluateExpression(_expression);
      setState(() {
        _displayText = result.toString();
        _expression = result.toString(); // Update expression with result
      });
    } catch (e) {
      setState(() {
        _displayText = "Error";
        _expression = "";
      });
    }
  }

  double _evaluateExpression(String expression) {
    // Replace operators for Dart's eval functions
    final formattedExpression = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll(' ', '');

    // Handle empty expressions
    if (formattedExpression.isEmpty) return 0.0;

    try {
      final exp = Expression.parse(formattedExpression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(exp, {});
      return result.toDouble();
    } catch (e) {
      return 0.0; // Return 0.0 if any error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _displayText,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('÷'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('×'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('='),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _clear,
                  child: const Text('C'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          _appendToExpression(value);
        },
        child: Text(value),
      ),
    );
  }
}

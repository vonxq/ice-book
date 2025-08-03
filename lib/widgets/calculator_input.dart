import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatorInput extends StatefulWidget {
  final Function(double) onAmountChanged;

  const CalculatorInput({
    super.key,
    required this.onAmountChanged,
  });

  @override
  State<CalculatorInput> createState() => _CalculatorInputState();
}

class _CalculatorInputState extends State<CalculatorInput> {
  String _display = '0';
  double _result = 0.0;
  String _operation = '';
  bool _newNumber = true;
  bool _hasDecimal = false;

  @override
  Widget build(BuildContext context) {
    // 获取屏幕高度和底部安全区域
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - bottomPadding;
    
    // 动态计算按钮高度，确保适应屏幕
    final buttonHeight = (availableHeight * 0.08).clamp(50.0, 70.0);
    
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // 显示区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _display,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¥${NumberFormat('#,##0.00').format(_result)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          // 按钮区域
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 第一行：清除按钮
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildButton('C', _clearAll, buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('AC', _clearAll, buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('⌫', _backspace, buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('÷', () => _setOperation('÷'), buttonHeight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 第二行：7-8-9-×
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('7', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('8', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('9', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('×', () => _setOperation('×'), buttonHeight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 第三行：4-5-6--
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('4', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('5', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('6', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('-', () => _setOperation('-'), buttonHeight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 第四行：1-2-3-+
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildNumberButton('1', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('2', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumberButton('3', buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('+', () => _setOperation('+'), buttonHeight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 第五行：0-.-=
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildNumberButton('0', buttonHeight),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('.', _addDecimal, buttonHeight)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildButton('=', _calculate, buttonHeight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _isOperator(text) 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: _isOperator(text) 
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _addNumber(number),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOperator(String text) {
    return ['+', '-', '×', '÷', '='].contains(text);
  }

  void _addNumber(String number) {
    setState(() {
      if (_newNumber) {
        _display = number;
        _newNumber = false;
      } else {
        if (_display == '0') {
          _display = number;
        } else {
          _display += number;
        }
      }
      _updateResult();
    });
  }

  void _addDecimal() {
    setState(() {
      if (_newNumber) {
        _display = '0.';
        _newNumber = false;
        _hasDecimal = true;
      } else if (!_hasDecimal) {
        _display += '.';
        _hasDecimal = true;
      }
      _updateResult();
    });
  }

  void _setOperation(String operation) {
    setState(() {
      if (_operation.isNotEmpty && !_newNumber) {
        _calculate();
      }
      _operation = operation;
      _newNumber = true;
      _hasDecimal = false;
    });
  }

  void _calculate() {
    setState(() {
      if (_operation.isNotEmpty) {
        double currentNumber = double.parse(_display);
        switch (_operation) {
          case '+':
            _result += currentNumber;
            break;
          case '-':
            _result -= currentNumber;
            break;
          case '×':
            _result *= currentNumber;
            break;
          case '÷':
            if (currentNumber != 0) {
              _result /= currentNumber;
            }
            break;
        }
        _display = _result.toString();
        _operation = '';
        _newNumber = true;
        _hasDecimal = false;
        widget.onAmountChanged(_result);
      }
    });
  }

  void _clearAll() {
    setState(() {
      _display = '0';
      _result = 0.0;
      _operation = '';
      _newNumber = true;
      _hasDecimal = false;
      widget.onAmountChanged(0.0);
    });
  }

  void _backspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        if (_display.endsWith('.')) {
          _hasDecimal = false;
        }
      } else {
        _display = '0';
        _newNumber = true;
      }
      _updateResult();
    });
  }

  void _updateResult() {
    try {
      _result = double.parse(_display);
      widget.onAmountChanged(_result);
    } catch (e) {
      _result = 0.0;
      widget.onAmountChanged(0.0);
    }
  }
} 
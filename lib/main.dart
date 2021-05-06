import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget{
  Calculator({Key key}) : super(key : key);
  @override
  _CalculatorState createState() => _CalculatorState();
}
var calculate = {
  '+' : (pre, pos) => pre + pos,
  '-' : (pre, pos) => pre - pos,
  'x' : (pre, pos) => pre * pos,
  '÷' : (pre, pos) => pre / pos,
  '=' : (pre, pos) => pos,
};

class _CalculatorState extends State<Calculator>{
  var value;
  var _output = '0';
  var output = '0.0';
  var operand = '';
  var waitResult = false;

  buttonPressed(String text) {
    if (text == 'AC') {
      setState(() {
        value = null;
        _output = '0';
        output = '0.0';
        operand = '';
        waitResult = false;
      });
    } else if (text == 'C') {
      setState(() {
        _output = '0';
        output ='0.0';
      });
    } else if (text == '+/-') {
      _output = '-' + _output;
      setState(() {
        output = double.parse(_output).toString();
      });
    } else if (text == '%') {
      _output = (double.parse(_output) / 100).toString();
      setState(() {
        output = double.parse(_output).toString();
      });
    } else if (text == '+' || text == '-' || text == 'x' || text == '÷' || text == '=') {
      double valB = double.parse(output);
      var nextOperand = text; //將運算符儲存在下一個運算符變數裡
      if (value == null) {
        setState(() {
          value = valB;
        });
      } else if (operand != '') { //呼叫的是前一個運算符
        var valA = value ?? 0;
        var cal = calculate[operand](valA, valB); //呼叫的是前一個運算符，以做上一個運算符的運算

        setState(() {
          value = cal;
          output = value.toString();
        });
      }
      setState(() {
        waitResult = true;
        operand = nextOperand; //將前一個運算符更新成下一個運算符
        _output = '0';
      });
    } else if (text == '.') {
      if (_output.contains('.')) {
        return;
      } else {
        _output = _output + '.';
        waitResult = false;
      }
      setState(() {
        output = double.parse(_output).toString();
      });
    } else {
      if (waitResult) {
        setState(() {
          _output = _output + text;
          output = double.parse(_output).toString();
          waitResult = false;
        });
      } else {
        setState(() {
          _output = _output + text;
          output = double.parse(_output).toString();
        });
      }
    }
  }

  Widget calKey(String text){
    double size = MediaQuery.of(context).size.width/4;
    return new Container(
      width: (text == '0') ? (size*2) : size,
      padding: EdgeInsets.all(5),
      height: size,
        child: new ElevatedButton(
          child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
          ),
          onPressed: () => buttonPressed(text),
        ),
    );
  }

  @override
  Widget build(BuildContext context){
    Size screen = MediaQuery.of(context).size;
    double buttonSize = screen.width/4;
    double displayHeight = screen.height- (buttonSize*5.5);
    double margin = displayHeight/10;
    var clearAll = output != '0.0';
    var clear = clearAll ? 'C' : 'AC';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: margin, bottom: margin),
        // constraints: BoxConstraints.expand(height: displayHeight),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(32, 130, 32, 16),
            constraints: BoxConstraints.expand(height: displayHeight),
            decoration: BoxDecoration(color: Colors.black),
            child: AutoSizeText(
                output,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w300),
                )
           ),
          new Column(
            children: [
              Row(
                children: <Widget>[
                calKey(clear),
                calKey('+/-'),
                calKey('%'),
                calKey('÷'),
                ],
              ),
              Row(
                children: <Widget>[
                calKey('7'),
                calKey('8'),
                calKey('9'),
                calKey('x'),
                ],
              ),
              Row(
                children: <Widget>[
                calKey('4'),
                calKey('5'),
                calKey('6'),
                calKey('-'),
                ],
              ),
              Row(
                children: <Widget>[
                calKey('1'),
                calKey('2'),
                calKey('3'),
                calKey('+'),
                ],
              ),
              Row(
                children: <Widget>[
                calKey('0'),
                calKey('.'),
                calKey('='),
                ],
              ),
            ]
          )
        ]
      )));
  }
}

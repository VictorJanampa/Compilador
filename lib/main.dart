import 'package:flutter/material.dart';
import 'package:mobile_compiler/constants.dart';
import 'package:mobile_compiler/grammar_class.dart';

const kTextFieldDecoration = InputDecoration(
    hintText: "<Input a Grammar>",
    border: InputBorder.none,
    hintStyle: TextStyle(
      color: Colors.white70,
    ),
    contentPadding: EdgeInsets.all(16));
const kWhiteTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compiler Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Grammar grammar;
  TextEditingController controller;
  String text = '';
  String value = '';

  @override
  void initState() {
    super.initState();
    grammar = Grammar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: primaryColor,
          ),
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.all(24.0),
                  color: secondaryColor,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: controller,
                    textInputAction: TextInputAction.newline,
                    decoration: kTextFieldDecoration,
                    style: kWhiteTextStyle,
                    onChanged: (value) {
                      this.value = value;
                    },
                  ),
                ),
              ),
              Container(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Container(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      Text(
                        'Run',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  grammar.fromText(text);
                  grammar.getFirsts();
                  setState(() {
                    text = value;
                  });
                },
              )),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(24.0),
                  color: secondaryColor,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

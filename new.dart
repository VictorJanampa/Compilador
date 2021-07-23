import 'dart:core';
import 'dart:convert';

String grammarText =
    "E -> T E'\nE' -> + T E'\nE' -> ''\nT -> F T'\nT' -> * F T'\nT' -> ''\nF -> ( E )\nF -> id";

class Production {
  var key;
  List<List<String>> value = [];
}

class Grammar {
  Map<String, List<List<String>>> _productions = new Map();
  List<List<String>> get_first =[];
  List<String> first=[];
  List<List<String>> get_next =[];
  List<String> next=[];
  //Map<String, List<String>> first = Map();
  //Map<String, List<String>> next = Map();

  Map<String, List<List<String>>> getProductions() {
    return _productions;
  }

  void insertProduction(List production) {
    if (_productions.containsKey(production[0])) {
      _productions.update(production[0], (value) => value + production[1]);
    } else
      _productions.putIfAbsent(production[0], () => production[1]);
  }

  dynamic fromLine(String S) {
    bool isFirstNT = true;
    String symbol = '';
    String key = '';
    List<String> value = [];

    for (var i = 0; i < S.length; i++) {
      if (S[i] == ' ') {
        if (isFirstNT) {
          key = symbol;
          symbol = '';
          isFirstNT = false;
        } else {
          if (symbol == "->" || symbol == '') {
            symbol = '';
          } else
            value.add(symbol);
          symbol = '';
        }
      } else
        symbol += S[i];
    }
    value.add(symbol);
    return [
      key,
      [value]
    ];
  }

  void fromText(String text) {
    List grammarList = text.split('\n');
    for (var line in grammarList) {
      insertProduction(fromLine(line));
    }
  }

  void printMap() {
    _productions.forEach((k, v) {
      print('$k -> $v');
    });
  }

  void get_First_(String x){
    List temp =_productions[x]! as List;
    print(temp);
    for(var pos in temp)
    {
      print(pos);
    if (_productions.containsKey(pos[0])==true){
      get_First_(pos[0]);
      }
    else{
      get_first[get_first.length-1].add(pos[0]);
      }
    }
    //if (_productions.containsKey(temp[0])==true){
    //  get_First_(temp[0]);
    //}
    //else{
    //  get_first[get_first.length-1].add(temp[0]);
    //}
  }

  void getFirsts() {
    for (var x in _productions.keys) {
      //print('Firsts of $x :');
      //print(_productions[x]);
      first.add(x);
      get_first.add([]);
      get_First_(x);
      
    }
  }
}
main() {
  Grammar grammar = Grammar();
  grammar.fromText(grammarText);
  //print(grammar._productions);
  //print(grammar._productions);
  grammar.getFirsts();
  print(grammar.first);
  print(grammar.get_first);
  //grammar.printMap();
  //grammar.primeros_();
  //print(grammar.first);
}

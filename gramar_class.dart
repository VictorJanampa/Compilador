import 'dart:core';

String grammarText =
    "E -> T E'\nE' -> + T E'\nE' -> ''\nT -> F T'\nT' -> * F T'\nT' -> ''\nF -> ( E )\nF -> id";

class Production {
  var key;
  List<List<String>> value=[];
}

class Grammar {
  Map<String, List<List<String>>> _productions = Map();
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
}

main() {
  Grammar grammar = Grammar();
  grammar.fromText(grammarText);
  grammar.printMap();
}

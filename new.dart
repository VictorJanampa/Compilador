import 'dart:core';
import 'dart:io';

String grammarText =
    "E -> T E'\nE' -> + T E'\nE' -> ''\nT -> F T'\nT' -> * F T'\nT' -> ''\nF -> ( E )\nF -> id";

class Production {
  var key;
  List<List<String>> value = [];
}

class Grammar {
  Map<String, List<List<String>>> _productions = new Map();
  Map<String, List<String>> first = Map();
  Map<String, List<String>> next = Map();

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

  void addfirst(String s, String pos) {
    List<String> f = [];
    f.add(s);
    first.update(pos, (value) => value + f, ifAbsent: () => f);
  }

  void addlast(String s, String pos) {
    List<String> f = [];
    f.add(s);
    next.update(pos, (value) => value + f, ifAbsent: () => f);
  }

  void regla2(String B, String b) {
    next.update(B, (value) => first[b], ifAbsent: () => first[b]);
  }

  void regla3(String B, String A) {
    next.update(B, (value) => next[A], ifAbsent: () => next[A]);
  }

  void getFirsts_(String S, String pos) {
    print(_productions[S]);
    if (!_productions.containsKey(S)) {
      if (first[pos]?.contains(S) == null) {
        addfirst(S, pos);
      }
    } else {
      for (var i in _productions[S] ?? []) {
        getFirsts_(i[0], pos);
      }
    }
    //primera regla
  }

  void getFirsts() {
    for (var x in _productions.keys) {
      print('Firsts of $x :');
      getFirsts_(x, x);
    }
  }

  void getnext_(String S, String pos) {
    print(_productions[S]);
    if (!_productions.containsKey(S)) {
    } else {
      //segunda regla
      if (_productions[S]?.length == 3) {
        regla2(_productions[S][2], _productions[S][1]);
      }
      if (_productions[S]?.length == 2) {
        regla2(_productions[S][1], S);
      }
    }
    //primera regla
  }

  void getnext() {
    bool primera_regla = true;
    for (var x in _productions.keys) {
      if (primera_regla == true) {
        addlast('&', x);
        primera_regla = false;
      }
      print('Firsts of $x :');
      getFirsts_(x, x);
    }
  }
}

main() {
  Grammar grammar = Grammar();
  grammar.fromText(grammarText);
  //print(grammar._productions);
  print(grammar._productions);
  grammar.getFirsts();
  print(grammar.first);
  //grammar.printMap();
  //grammar.primeros_();
  //print(grammar.first);
  print("{E:[(,id],E':[+,''],T:[(,id],T':[*,''],F:[(,id]}");
}

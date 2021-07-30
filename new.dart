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
  List<List<String>> get_first = [];
  List<String> first = [];
  List<List<String>> get_next = [];
  List<String> next = [];
  bool n_terminal = true;
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

  void get_First_(String x) {
    List temp = _productions[x]! as List;
    print(temp);
    for (var pos in temp) {
      print(pos);
      if (_productions.containsKey(pos[0]) == true) {
        get_First_(pos[0]);
      } else {
        get_first[get_first.length - 1].add(pos[0]);
      }
    }
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

  bool regla1() {
    if (n_terminal == true) {
      n_terminal = false;
      return true;
    } else {
      return false;
    }
  }

  void regla1_aplicar(String x) {
    get_next[get_next.length - 1].add('');
  }

  bool regla2(List temp, String x) {
    int p = -1;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i] == x) {
        p = i;
      }
    }
    if (p != -1) {
      if (p == temp.length - 1) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void regla2_aplicar(String keyA, String keyB) {
    int ka = 0;
    int kb = 0;
    for (var i = 0; i < next.length; i++) {
      if (next[i] == keyA) {
        ka = i;
      }
      if (next[i] == keyB) {
        kb = i;
      }
    }
    get_next[kb] = get_next[ka];
  }

  bool regla3(List temp, String x) {
    int p = -1;
    for (var i = 0; i < temp.length; i++) {
      if (temp[i] == x) {
        p = i;
      }
    }
    if (p != -1) {
      if (p == temp.length - 1) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void regla3_aplicar1(String keyA, String keyB) {
    int ka = 0;
    int kb = 0;
    for (var i = 0; i < next.length; i++) {
      if (next[i] == keyA) {
        ka = i;
      }
      if (next[i] == keyB) {
        kb = i;
      }
    }
    get_next[ka] = get_next[kb];
  }

  void regla3_aplicar2(String keyA, String keyB, String keyb) {
    int ka = 0;
    int kB = 0;
    int kb = 0;
    for (var i = 0; i < next.length; i++) {
      if (next[i] == keyA) {
        ka = i;
      }
      if (next[i] == keyB) {
        kB = i;
      }
      if (next[i] == keyb) {
        kb = i;
      }
    }
    get_next[kB] = get_first[kb];
    for (var i = 0; i < get_next[ka].length; i++) {
      if (get_next[kB].contains(get_next[ka][i]) == false) {
        get_next[kB].add(get_next[ka][i]);
      }
    }
  }

  void get_next_(String x) {
    List temp = _productions[x]! as List;
    print(temp);
    for (var pos in temp) {
      print(pos);
      if (_productions.containsKey(pos[0]) == true) {
        get_First_(pos[0]);
      } else {
        get_first[get_first.length - 1].add(pos[0]);
      }
    }
  }

  void get_nexts() {
    for (var x in _productions.keys) {
      //print('Firsts of $x :');
      //print(_productions[x]);
      next.add(x);
      get_next.add([]);
      get_next_(x);
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

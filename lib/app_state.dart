import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _chathistory = prefs
              .getStringList('ff_chathistory')
              ?.map((x) {
                try {
                  return AIChatStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _chathistory;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
  }

  List<AIChatStruct> _chathistory = [];
  List<AIChatStruct> get chathistory => _chathistory;
  set chathistory(List<AIChatStruct> value) {
    _chathistory = value;
    prefs.setStringList(
        'ff_chathistory', value.map((x) => x.serialize()).toList());
  }

  void addToChathistory(AIChatStruct value) {
    chathistory.add(value);
    prefs.setStringList(
        'ff_chathistory', _chathistory.map((x) => x.serialize()).toList());
  }

  void removeFromChathistory(AIChatStruct value) {
    chathistory.remove(value);
    prefs.setStringList(
        'ff_chathistory', _chathistory.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromChathistory(int index) {
    chathistory.removeAt(index);
    prefs.setStringList(
        'ff_chathistory', _chathistory.map((x) => x.serialize()).toList());
  }

  void updateChathistoryAtIndex(
    int index,
    AIChatStruct Function(AIChatStruct) updateFn,
  ) {
    chathistory[index] = updateFn(_chathistory[index]);
    prefs.setStringList(
        'ff_chathistory', _chathistory.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInChathistory(int index, AIChatStruct value) {
    chathistory.insert(index, value);
    prefs.setStringList(
        'ff_chathistory', _chathistory.map((x) => x.serialize()).toList());
  }

  List<String> _n = ['-', '-'];
  List<String> get n => _n;
  set n(List<String> value) {
    _n = value;
  }

  void addToN(String value) {
    n.add(value);
  }

  void removeFromN(String value) {
    n.remove(value);
  }

  void removeAtIndexFromN(int index) {
    n.removeAt(index);
  }

  void updateNAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    n[index] = updateFn(_n[index]);
  }

  void insertAtIndexInN(int index, String value) {
    n.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

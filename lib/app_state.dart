import 'dart:async';

import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static const chatHistoryPersistDebounce = Duration(milliseconds: 250);
  static const _chatHistoryPrefsKey = 'ff_chathistory';

  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance._chatHistoryPersistTimer?.cancel();
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _chathistory = prefs
              .getStringList(_chatHistoryPrefsKey)
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
    _safeInit(() {
      _acceptedRoastRules =
          prefs.getBool(_acceptedRoastRulesPrefsKey) ?? false;
    });
  }

  static const _acceptedRoastRulesPrefsKey = 'ff_accepted_roast_rules';
  bool _acceptedRoastRules = false;
  bool get acceptedRoastRules => _acceptedRoastRules;
  set acceptedRoastRules(bool value) {
    _acceptedRoastRules = value;
    prefs.setBool(_acceptedRoastRulesPrefsKey, value);
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;
  Timer? _chatHistoryPersistTimer;
  Future<void>? _chatHistoryPersistInFlight;
  bool _chatHistoryPersistDirty = false;
  int _chatHistoryPersistWriteCount = 0;

  int get chatHistoryPersistWriteCount => _chatHistoryPersistWriteCount;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
  }

  List<AIChatStruct> _chathistory = [];
  List<AIChatStruct> get chathistory => _chathistory;
  set chathistory(List<AIChatStruct> value) {
    _chathistory = value;
    _scheduleChatHistoryPersist();
  }

  void addToChathistory(AIChatStruct value) {
    chathistory.add(value);
    _scheduleChatHistoryPersist();
  }

  void removeFromChathistory(AIChatStruct value) {
    chathistory.remove(value);
    _scheduleChatHistoryPersist();
  }

  void removeAtIndexFromChathistory(int index) {
    chathistory.removeAt(index);
    _scheduleChatHistoryPersist();
  }

  void updateChathistoryAtIndex(
    int index,
    AIChatStruct Function(AIChatStruct) updateFn,
  ) {
    chathistory[index] = updateFn(_chathistory[index]);
    _scheduleChatHistoryPersist();
  }

  void insertAtIndexInChathistory(int index, AIChatStruct value) {
    chathistory.insert(index, value);
    _scheduleChatHistoryPersist();
  }

  Future<void> flushChatHistoryPersistence() async {
    await _persistPendingChatHistory();
  }

  void _scheduleChatHistoryPersist() {
    _chatHistoryPersistDirty = true;
    _chatHistoryPersistTimer?.cancel();
    _chatHistoryPersistTimer = Timer(
      chatHistoryPersistDebounce,
      () {
        unawaited(_persistPendingChatHistory());
      },
    );
  }

  Future<void> _persistPendingChatHistory() async {
    _chatHistoryPersistTimer?.cancel();
    _chatHistoryPersistTimer = null;

    if (!_chatHistoryPersistDirty) {
      await _chatHistoryPersistInFlight;
      return;
    }

    final serialized = _chathistory.map((x) => x.serialize()).toList();
    _chatHistoryPersistDirty = false;

    late final Future<void> write;
    write = prefs.setStringList(_chatHistoryPrefsKey, serialized).then((_) {
      _chatHistoryPersistWriteCount += 1;
    });

    _chatHistoryPersistInFlight = write;
    try {
      await write;
    } finally {
      if (identical(_chatHistoryPersistInFlight, write)) {
        _chatHistoryPersistInFlight = null;
      }
    }
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

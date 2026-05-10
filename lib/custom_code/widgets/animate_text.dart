// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shared_preferences/shared_preferences.dart';

class AnimateText extends StatefulWidget {
  const AnimateText({
    super.key,
    this.width,
    this.height, // оставляем для совместимости, внутри не используем
    required this.text,
    required this.messageKey, // передавай стабильный id сообщения (лучше documentId)
    this.charDelayMs = 20,
  });

  final double? width;
  final double? height;
  final String text;
  final String messageKey;
  final int charDelayMs;

  @override
  State<AnimateText> createState() => _AnimateTextState();
}

class _AnimateTextState extends State<AnimateText> {
  static const String _doneKeysStorage = 'animated_done_keys_v2';
  static final Set<String> _doneInMemory = <String>{};

  String _animatedText = '';
  int _runId = 0;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.messageKey != widget.messageKey) {
      _startTypingAnimation();
    }
  }

  String _normalizeText(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

  String _hashFNV1a(String input) {
    int hash = 0x811C9DC5;
    for (final c in input.codeUnits) {
      hash ^= c;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  String _effectiveMessageId() {
    final key = widget.messageKey.trim();

    // Если messageKey нормальный и стабильный — используем его.
    if (key.isNotEmpty &&
        !key.startsWith('idx_') &&
        !key.startsWith('index_')) {
      return key;
    }

    // Fallback: стабильный ключ по контенту.
    return 'txt_${_hashFNV1a(_normalizeText(widget.text))}';
  }

  Future<Set<String>> _loadDoneSet(SharedPreferences prefs) async {
    final list = prefs.getStringList(_doneKeysStorage) ?? const <String>[];
    return list.toSet();
  }

  Future<bool> _alreadyAnimated(
    SharedPreferences prefs,
    String id,
  ) async {
    if (_doneInMemory.contains(id)) return true;

    final doneSet = await _loadDoneSet(prefs);
    if (doneSet.contains(id)) {
      _doneInMemory.add(id);
      return true;
    }

    // Миграция со старого ключа, если раньше было так:
    final legacyKey = 'animated_done_${widget.messageKey}';
    final legacyDone = prefs.getBool(legacyKey) ?? false;
    if (legacyDone) {
      doneSet.add(id);
      await prefs.setStringList(_doneKeysStorage, doneSet.toList());
      _doneInMemory.add(id);
      return true;
    }

    return false;
  }

  Future<void> _markAnimated(
    SharedPreferences prefs,
    String id,
  ) async {
    _doneInMemory.add(id);
    final doneSet = await _loadDoneSet(prefs);
    doneSet.add(id);
    await prefs.setStringList(_doneKeysStorage, doneSet.toList());
  }

  Future<void> _startTypingAnimation() async {
    final currentRun = ++_runId;
    final text = widget.text;

    if (!mounted) return;
    if (text.isEmpty) {
      setState(() => _animatedText = '');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (!mounted || currentRun != _runId) return;

    final id = _effectiveMessageId();
    final done = await _alreadyAnimated(prefs, id);
    if (!mounted || currentRun != _runId) return;

    if (done) {
      setState(() => _animatedText = text);
      return;
    }

    setState(() => _animatedText = '');

    final delayMs = widget.charDelayMs.clamp(10, 250);
    for (int i = 1; i <= text.length; i++) {
      await Future.delayed(Duration(milliseconds: delayMs));
      if (!mounted || currentRun != _runId) return;
      setState(() => _animatedText = text.substring(0, i));
    }

    await _markAnimated(prefs, id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Text(
        _animatedText,
        softWrap: true,
        style: const TextStyle(
          color: Color(0xFF1C1C1C),
          fontSize: 15,
          fontWeight: FontWeight.normal,
          height: 1.538,
        ),
      ),
    );
  }
}

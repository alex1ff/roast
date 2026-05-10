// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AIChatStruct extends FFFirebaseStruct {
  AIChatStruct({
    String? message,
    String? role,
    bool? isFirst,
    String? dish,
    int? kkal,
    DateTime? date,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _message = message,
        _role = role,
        _isFirst = isFirst,
        _dish = dish,
        _kkal = kkal,
        _date = date,
        super(firestoreUtilData);

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;

  bool hasMessage() => _message != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "isFirst" field.
  bool? _isFirst;
  bool get isFirst => _isFirst ?? false;
  set isFirst(bool? val) => _isFirst = val;

  bool hasIsFirst() => _isFirst != null;

  // "dish" field.
  String? _dish;
  String get dish => _dish ?? '';
  set dish(String? val) => _dish = val;

  bool hasDish() => _dish != null;

  // "kkal" field.
  int? _kkal;
  int get kkal => _kkal ?? 0;
  set kkal(int? val) => _kkal = val;

  void incrementKkal(int amount) => kkal = kkal + amount;

  bool hasKkal() => _kkal != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  static AIChatStruct fromMap(Map<String, dynamic> data) => AIChatStruct(
        message: data['message'] as String?,
        role: data['role'] as String?,
        isFirst: data['isFirst'] as bool?,
        dish: data['dish'] as String?,
        kkal: castToType<int>(data['kkal']),
        date: data['date'] as DateTime?,
      );

  static AIChatStruct? maybeFromMap(dynamic data) =>
      data is Map ? AIChatStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'message': _message,
        'role': _role,
        'isFirst': _isFirst,
        'dish': _dish,
        'kkal': _kkal,
        'date': _date,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'isFirst': serializeParam(
          _isFirst,
          ParamType.bool,
        ),
        'dish': serializeParam(
          _dish,
          ParamType.String,
        ),
        'kkal': serializeParam(
          _kkal,
          ParamType.int,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static AIChatStruct fromSerializableMap(Map<String, dynamic> data) =>
      AIChatStruct(
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        isFirst: deserializeParam(
          data['isFirst'],
          ParamType.bool,
          false,
        ),
        dish: deserializeParam(
          data['dish'],
          ParamType.String,
          false,
        ),
        kkal: deserializeParam(
          data['kkal'],
          ParamType.int,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'AIChatStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AIChatStruct &&
        message == other.message &&
        role == other.role &&
        isFirst == other.isFirst &&
        dish == other.dish &&
        kkal == other.kkal &&
        date == other.date;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([message, role, isFirst, dish, kkal, date]);
}

AIChatStruct createAIChatStruct({
  String? message,
  String? role,
  bool? isFirst,
  String? dish,
  int? kkal,
  DateTime? date,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AIChatStruct(
      message: message,
      role: role,
      isFirst: isFirst,
      dish: dish,
      kkal: kkal,
      date: date,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AIChatStruct? updateAIChatStruct(
  AIChatStruct? aIChat, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    aIChat
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAIChatStructData(
  Map<String, dynamic> firestoreData,
  AIChatStruct? aIChat,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (aIChat == null) {
    return;
  }
  if (aIChat.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && aIChat.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final aIChatData = getAIChatFirestoreData(aIChat, forFieldValue);
  final nestedData = aIChatData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = aIChat.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAIChatFirestoreData(
  AIChatStruct? aIChat, [
  bool forFieldValue = false,
]) {
  if (aIChat == null) {
    return {};
  }
  final firestoreData = mapToFirestore(aIChat.toMap());

  // Add any Firestore field values
  mapToFirestore(aIChat.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAIChatListFirestoreData(
  List<AIChatStruct>? aIChats,
) =>
    aIChats?.map((e) => getAIChatFirestoreData(e, true)).toList() ?? [];

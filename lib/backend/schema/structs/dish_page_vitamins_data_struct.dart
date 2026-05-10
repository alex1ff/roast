// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DishPageVitaminsDataStruct extends FFFirebaseStruct {
  DishPageVitaminsDataStruct({
    String? vitamin,
    String? description,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _vitamin = vitamin,
        _description = description,
        super(firestoreUtilData);

  // "vitamin" field.
  String? _vitamin;
  String get vitamin => _vitamin ?? '';
  set vitamin(String? val) => _vitamin = val;

  bool hasVitamin() => _vitamin != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static DishPageVitaminsDataStruct fromMap(Map<String, dynamic> data) =>
      DishPageVitaminsDataStruct(
        vitamin: data['vitamin'] as String?,
        description: data['description'] as String?,
      );

  static DishPageVitaminsDataStruct? maybeFromMap(dynamic data) => data is Map
      ? DishPageVitaminsDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'vitamin': _vitamin,
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'vitamin': serializeParam(
          _vitamin,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static DishPageVitaminsDataStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DishPageVitaminsDataStruct(
        vitamin: deserializeParam(
          data['vitamin'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DishPageVitaminsDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DishPageVitaminsDataStruct &&
        vitamin == other.vitamin &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash([vitamin, description]);
}

DishPageVitaminsDataStruct createDishPageVitaminsDataStruct({
  String? vitamin,
  String? description,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DishPageVitaminsDataStruct(
      vitamin: vitamin,
      description: description,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DishPageVitaminsDataStruct? updateDishPageVitaminsDataStruct(
  DishPageVitaminsDataStruct? dishPageVitaminsData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dishPageVitaminsData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDishPageVitaminsDataStructData(
  Map<String, dynamic> firestoreData,
  DishPageVitaminsDataStruct? dishPageVitaminsData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dishPageVitaminsData == null) {
    return;
  }
  if (dishPageVitaminsData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dishPageVitaminsData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dishPageVitaminsDataData =
      getDishPageVitaminsDataFirestoreData(dishPageVitaminsData, forFieldValue);
  final nestedData =
      dishPageVitaminsDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dishPageVitaminsData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDishPageVitaminsDataFirestoreData(
  DishPageVitaminsDataStruct? dishPageVitaminsData, [
  bool forFieldValue = false,
]) {
  if (dishPageVitaminsData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dishPageVitaminsData.toMap());

  // Add any Firestore field values
  mapToFirestore(dishPageVitaminsData.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDishPageVitaminsDataListFirestoreData(
  List<DishPageVitaminsDataStruct>? dishPageVitaminsDatas,
) =>
    dishPageVitaminsDatas
        ?.map((e) => getDishPageVitaminsDataFirestoreData(e, true))
        .toList() ??
    [];

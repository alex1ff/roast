// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AnalyzeAPIDataStruct extends FFFirebaseStruct {
  AnalyzeAPIDataStruct({
    String? dishName,
    int? dishWeight,
    String? dishPhoto,
    String? restaurant,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _dishName = dishName,
        _dishWeight = dishWeight,
        _dishPhoto = dishPhoto,
        _restaurant = restaurant,
        super(firestoreUtilData);

  // "dish_name" field.
  String? _dishName;
  String get dishName => _dishName ?? '';
  set dishName(String? val) => _dishName = val;

  bool hasDishName() => _dishName != null;

  // "dish_weight" field.
  int? _dishWeight;
  int get dishWeight => _dishWeight ?? 0;
  set dishWeight(int? val) => _dishWeight = val;

  void incrementDishWeight(int amount) => dishWeight = dishWeight + amount;

  bool hasDishWeight() => _dishWeight != null;

  // "dish_photo" field.
  String? _dishPhoto;
  String get dishPhoto => _dishPhoto ?? '';
  set dishPhoto(String? val) => _dishPhoto = val;

  bool hasDishPhoto() => _dishPhoto != null;

  // "restaurant" field.
  String? _restaurant;
  String get restaurant => _restaurant ?? '';
  set restaurant(String? val) => _restaurant = val;

  bool hasRestaurant() => _restaurant != null;

  static AnalyzeAPIDataStruct fromMap(Map<String, dynamic> data) =>
      AnalyzeAPIDataStruct(
        dishName: data['dish_name'] as String?,
        dishWeight: castToType<int>(data['dish_weight']),
        dishPhoto: data['dish_photo'] as String?,
        restaurant: data['restaurant'] as String?,
      );

  static AnalyzeAPIDataStruct? maybeFromMap(dynamic data) => data is Map
      ? AnalyzeAPIDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dish_name': _dishName,
        'dish_weight': _dishWeight,
        'dish_photo': _dishPhoto,
        'restaurant': _restaurant,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dish_name': serializeParam(
          _dishName,
          ParamType.String,
        ),
        'dish_weight': serializeParam(
          _dishWeight,
          ParamType.int,
        ),
        'dish_photo': serializeParam(
          _dishPhoto,
          ParamType.String,
        ),
        'restaurant': serializeParam(
          _restaurant,
          ParamType.String,
        ),
      }.withoutNulls;

  static AnalyzeAPIDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      AnalyzeAPIDataStruct(
        dishName: deserializeParam(
          data['dish_name'],
          ParamType.String,
          false,
        ),
        dishWeight: deserializeParam(
          data['dish_weight'],
          ParamType.int,
          false,
        ),
        dishPhoto: deserializeParam(
          data['dish_photo'],
          ParamType.String,
          false,
        ),
        restaurant: deserializeParam(
          data['restaurant'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AnalyzeAPIDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnalyzeAPIDataStruct &&
        dishName == other.dishName &&
        dishWeight == other.dishWeight &&
        dishPhoto == other.dishPhoto &&
        restaurant == other.restaurant;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([dishName, dishWeight, dishPhoto, restaurant]);
}

AnalyzeAPIDataStruct createAnalyzeAPIDataStruct({
  String? dishName,
  int? dishWeight,
  String? dishPhoto,
  String? restaurant,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AnalyzeAPIDataStruct(
      dishName: dishName,
      dishWeight: dishWeight,
      dishPhoto: dishPhoto,
      restaurant: restaurant,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AnalyzeAPIDataStruct? updateAnalyzeAPIDataStruct(
  AnalyzeAPIDataStruct? analyzeAPIData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    analyzeAPIData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAnalyzeAPIDataStructData(
  Map<String, dynamic> firestoreData,
  AnalyzeAPIDataStruct? analyzeAPIData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (analyzeAPIData == null) {
    return;
  }
  if (analyzeAPIData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && analyzeAPIData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final analyzeAPIDataData =
      getAnalyzeAPIDataFirestoreData(analyzeAPIData, forFieldValue);
  final nestedData =
      analyzeAPIDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = analyzeAPIData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnalyzeAPIDataFirestoreData(
  AnalyzeAPIDataStruct? analyzeAPIData, [
  bool forFieldValue = false,
]) {
  if (analyzeAPIData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(analyzeAPIData.toMap());

  // Add any Firestore field values
  mapToFirestore(analyzeAPIData.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnalyzeAPIDataListFirestoreData(
  List<AnalyzeAPIDataStruct>? analyzeAPIDatas,
) =>
    analyzeAPIDatas
        ?.map((e) => getAnalyzeAPIDataFirestoreData(e, true))
        .toList() ??
    [];

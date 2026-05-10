// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MainPhotoFlowStruct extends FFFirebaseStruct {
  MainPhotoFlowStruct({
    String? image,
    String? dishName,
    int? dishWeight,
    String? restaurant,
    List<String>? ingredientsToExcept,
    List<String>? ingredientsToAdd,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _image = image,
        _dishName = dishName,
        _dishWeight = dishWeight,
        _restaurant = restaurant,
        _ingredientsToExcept = ingredientsToExcept,
        _ingredientsToAdd = ingredientsToAdd,
        super(firestoreUtilData);

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

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

  // "restaurant" field.
  String? _restaurant;
  String get restaurant => _restaurant ?? '';
  set restaurant(String? val) => _restaurant = val;

  bool hasRestaurant() => _restaurant != null;

  // "ingredients_to_except" field.
  List<String>? _ingredientsToExcept;
  List<String> get ingredientsToExcept => _ingredientsToExcept ?? const [];
  set ingredientsToExcept(List<String>? val) => _ingredientsToExcept = val;

  void updateIngredientsToExcept(Function(List<String>) updateFn) {
    updateFn(_ingredientsToExcept ??= []);
  }

  bool hasIngredientsToExcept() => _ingredientsToExcept != null;

  // "ingredients_to_add" field.
  List<String>? _ingredientsToAdd;
  List<String> get ingredientsToAdd => _ingredientsToAdd ?? const [];
  set ingredientsToAdd(List<String>? val) => _ingredientsToAdd = val;

  void updateIngredientsToAdd(Function(List<String>) updateFn) {
    updateFn(_ingredientsToAdd ??= []);
  }

  bool hasIngredientsToAdd() => _ingredientsToAdd != null;

  static MainPhotoFlowStruct fromMap(Map<String, dynamic> data) =>
      MainPhotoFlowStruct(
        image: data['image'] as String?,
        dishName: data['dish_name'] as String?,
        dishWeight: castToType<int>(data['dish_weight']),
        restaurant: data['restaurant'] as String?,
        ingredientsToExcept: getDataList(data['ingredients_to_except']),
        ingredientsToAdd: getDataList(data['ingredients_to_add']),
      );

  static MainPhotoFlowStruct? maybeFromMap(dynamic data) => data is Map
      ? MainPhotoFlowStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'image': _image,
        'dish_name': _dishName,
        'dish_weight': _dishWeight,
        'restaurant': _restaurant,
        'ingredients_to_except': _ingredientsToExcept,
        'ingredients_to_add': _ingredientsToAdd,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'dish_name': serializeParam(
          _dishName,
          ParamType.String,
        ),
        'dish_weight': serializeParam(
          _dishWeight,
          ParamType.int,
        ),
        'restaurant': serializeParam(
          _restaurant,
          ParamType.String,
        ),
        'ingredients_to_except': serializeParam(
          _ingredientsToExcept,
          ParamType.String,
          isList: true,
        ),
        'ingredients_to_add': serializeParam(
          _ingredientsToAdd,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static MainPhotoFlowStruct fromSerializableMap(Map<String, dynamic> data) =>
      MainPhotoFlowStruct(
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
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
        restaurant: deserializeParam(
          data['restaurant'],
          ParamType.String,
          false,
        ),
        ingredientsToExcept: deserializeParam<String>(
          data['ingredients_to_except'],
          ParamType.String,
          true,
        ),
        ingredientsToAdd: deserializeParam<String>(
          data['ingredients_to_add'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'MainPhotoFlowStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MainPhotoFlowStruct &&
        image == other.image &&
        dishName == other.dishName &&
        dishWeight == other.dishWeight &&
        restaurant == other.restaurant &&
        listEquality.equals(ingredientsToExcept, other.ingredientsToExcept) &&
        listEquality.equals(ingredientsToAdd, other.ingredientsToAdd);
  }

  @override
  int get hashCode => const ListEquality().hash([
        image,
        dishName,
        dishWeight,
        restaurant,
        ingredientsToExcept,
        ingredientsToAdd
      ]);
}

MainPhotoFlowStruct createMainPhotoFlowStruct({
  String? image,
  String? dishName,
  int? dishWeight,
  String? restaurant,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MainPhotoFlowStruct(
      image: image,
      dishName: dishName,
      dishWeight: dishWeight,
      restaurant: restaurant,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MainPhotoFlowStruct? updateMainPhotoFlowStruct(
  MainPhotoFlowStruct? mainPhotoFlow, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mainPhotoFlow
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMainPhotoFlowStructData(
  Map<String, dynamic> firestoreData,
  MainPhotoFlowStruct? mainPhotoFlow,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mainPhotoFlow == null) {
    return;
  }
  if (mainPhotoFlow.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mainPhotoFlow.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mainPhotoFlowData =
      getMainPhotoFlowFirestoreData(mainPhotoFlow, forFieldValue);
  final nestedData =
      mainPhotoFlowData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mainPhotoFlow.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMainPhotoFlowFirestoreData(
  MainPhotoFlowStruct? mainPhotoFlow, [
  bool forFieldValue = false,
]) {
  if (mainPhotoFlow == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mainPhotoFlow.toMap());

  // Add any Firestore field values
  mapToFirestore(mainPhotoFlow.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMainPhotoFlowListFirestoreData(
  List<MainPhotoFlowStruct>? mainPhotoFlows,
) =>
    mainPhotoFlows
        ?.map((e) => getMainPhotoFlowFirestoreData(e, true))
        .toList() ??
    [];

// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DailyGoalStruct extends FFFirebaseStruct {
  DailyGoalStruct({
    int? kcal,
    int? proteins,
    int? carbs,
    int? fats,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _kcal = kcal,
        _proteins = proteins,
        _carbs = carbs,
        _fats = fats,
        super(firestoreUtilData);

  // "kcal" field.
  int? _kcal;
  int get kcal => _kcal ?? 0;
  set kcal(int? val) => _kcal = val;

  void incrementKcal(int amount) => kcal = kcal + amount;

  bool hasKcal() => _kcal != null;

  // "proteins" field.
  int? _proteins;
  int get proteins => _proteins ?? 0;
  set proteins(int? val) => _proteins = val;

  void incrementProteins(int amount) => proteins = proteins + amount;

  bool hasProteins() => _proteins != null;

  // "carbs" field.
  int? _carbs;
  int get carbs => _carbs ?? 0;
  set carbs(int? val) => _carbs = val;

  void incrementCarbs(int amount) => carbs = carbs + amount;

  bool hasCarbs() => _carbs != null;

  // "fats" field.
  int? _fats;
  int get fats => _fats ?? 0;
  set fats(int? val) => _fats = val;

  void incrementFats(int amount) => fats = fats + amount;

  bool hasFats() => _fats != null;

  static DailyGoalStruct fromMap(Map<String, dynamic> data) => DailyGoalStruct(
        kcal: castToType<int>(data['kcal']),
        proteins: castToType<int>(data['proteins']),
        carbs: castToType<int>(data['carbs']),
        fats: castToType<int>(data['fats']),
      );

  static DailyGoalStruct? maybeFromMap(dynamic data) => data is Map
      ? DailyGoalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'kcal': _kcal,
        'proteins': _proteins,
        'carbs': _carbs,
        'fats': _fats,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'kcal': serializeParam(
          _kcal,
          ParamType.int,
        ),
        'proteins': serializeParam(
          _proteins,
          ParamType.int,
        ),
        'carbs': serializeParam(
          _carbs,
          ParamType.int,
        ),
        'fats': serializeParam(
          _fats,
          ParamType.int,
        ),
      }.withoutNulls;

  static DailyGoalStruct fromSerializableMap(Map<String, dynamic> data) =>
      DailyGoalStruct(
        kcal: deserializeParam(
          data['kcal'],
          ParamType.int,
          false,
        ),
        proteins: deserializeParam(
          data['proteins'],
          ParamType.int,
          false,
        ),
        carbs: deserializeParam(
          data['carbs'],
          ParamType.int,
          false,
        ),
        fats: deserializeParam(
          data['fats'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DailyGoalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DailyGoalStruct &&
        kcal == other.kcal &&
        proteins == other.proteins &&
        carbs == other.carbs &&
        fats == other.fats;
  }

  @override
  int get hashCode => const ListEquality().hash([kcal, proteins, carbs, fats]);
}

DailyGoalStruct createDailyGoalStruct({
  int? kcal,
  int? proteins,
  int? carbs,
  int? fats,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DailyGoalStruct(
      kcal: kcal,
      proteins: proteins,
      carbs: carbs,
      fats: fats,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DailyGoalStruct? updateDailyGoalStruct(
  DailyGoalStruct? dailyGoal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dailyGoal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDailyGoalStructData(
  Map<String, dynamic> firestoreData,
  DailyGoalStruct? dailyGoal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dailyGoal == null) {
    return;
  }
  if (dailyGoal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dailyGoal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dailyGoalData = getDailyGoalFirestoreData(dailyGoal, forFieldValue);
  final nestedData = dailyGoalData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dailyGoal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDailyGoalFirestoreData(
  DailyGoalStruct? dailyGoal, [
  bool forFieldValue = false,
]) {
  if (dailyGoal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dailyGoal.toMap());

  // Add any Firestore field values
  mapToFirestore(dailyGoal.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDailyGoalListFirestoreData(
  List<DailyGoalStruct>? dailyGoals,
) =>
    dailyGoals?.map((e) => getDailyGoalFirestoreData(e, true)).toList() ?? [];

// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CpcfStruct extends FFFirebaseStruct {
  CpcfStruct({
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

  static CpcfStruct fromMap(Map<String, dynamic> data) => CpcfStruct(
        kcal: castToType<int>(data['kcal']),
        proteins: castToType<int>(data['proteins']),
        carbs: castToType<int>(data['carbs']),
        fats: castToType<int>(data['fats']),
      );

  static CpcfStruct? maybeFromMap(dynamic data) =>
      data is Map ? CpcfStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static CpcfStruct fromSerializableMap(Map<String, dynamic> data) =>
      CpcfStruct(
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
  String toString() => 'CpcfStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CpcfStruct &&
        kcal == other.kcal &&
        proteins == other.proteins &&
        carbs == other.carbs &&
        fats == other.fats;
  }

  @override
  int get hashCode => const ListEquality().hash([kcal, proteins, carbs, fats]);
}

CpcfStruct createCpcfStruct({
  int? kcal,
  int? proteins,
  int? carbs,
  int? fats,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CpcfStruct(
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

CpcfStruct? updateCpcfStruct(
  CpcfStruct? cpcf, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cpcf
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCpcfStructData(
  Map<String, dynamic> firestoreData,
  CpcfStruct? cpcf,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cpcf == null) {
    return;
  }
  if (cpcf.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && cpcf.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cpcfData = getCpcfFirestoreData(cpcf, forFieldValue);
  final nestedData = cpcfData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cpcf.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCpcfFirestoreData(
  CpcfStruct? cpcf, [
  bool forFieldValue = false,
]) {
  if (cpcf == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cpcf.toMap());

  // Add any Firestore field values
  mapToFirestore(cpcf.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCpcfListFirestoreData(
  List<CpcfStruct>? cpcfs,
) =>
    cpcfs?.map((e) => getCpcfFirestoreData(e, true)).toList() ?? [];

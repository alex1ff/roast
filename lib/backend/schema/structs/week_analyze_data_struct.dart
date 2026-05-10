// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeekAnalyzeDataStruct extends FFFirebaseStruct {
  WeekAnalyzeDataStruct({
    CpcfStruct? goal,
    Cpcf2Struct? average,
    Cpcf3Struct? balance,
    String? overage,
    List<String>? biggestSources,
    List<String>? adjustTips,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _goal = goal,
        _average = average,
        _balance = balance,
        _overage = overage,
        _biggestSources = biggestSources,
        _adjustTips = adjustTips,
        super(firestoreUtilData);

  // "goal" field.
  CpcfStruct? _goal;
  CpcfStruct get goal => _goal ?? CpcfStruct();
  set goal(CpcfStruct? val) => _goal = val;

  void updateGoal(Function(CpcfStruct) updateFn) {
    updateFn(_goal ??= CpcfStruct());
  }

  bool hasGoal() => _goal != null;

  // "average" field.
  Cpcf2Struct? _average;
  Cpcf2Struct get average => _average ?? Cpcf2Struct();
  set average(Cpcf2Struct? val) => _average = val;

  void updateAverage(Function(Cpcf2Struct) updateFn) {
    updateFn(_average ??= Cpcf2Struct());
  }

  bool hasAverage() => _average != null;

  // "balance" field.
  Cpcf3Struct? _balance;
  Cpcf3Struct get balance => _balance ?? Cpcf3Struct();
  set balance(Cpcf3Struct? val) => _balance = val;

  void updateBalance(Function(Cpcf3Struct) updateFn) {
    updateFn(_balance ??= Cpcf3Struct());
  }

  bool hasBalance() => _balance != null;

  // "overage" field.
  String? _overage;
  String get overage => _overage ?? '';
  set overage(String? val) => _overage = val;

  bool hasOverage() => _overage != null;

  // "biggest_sources" field.
  List<String>? _biggestSources;
  List<String> get biggestSources => _biggestSources ?? const [];
  set biggestSources(List<String>? val) => _biggestSources = val;

  void updateBiggestSources(Function(List<String>) updateFn) {
    updateFn(_biggestSources ??= []);
  }

  bool hasBiggestSources() => _biggestSources != null;

  // "adjust_tips" field.
  List<String>? _adjustTips;
  List<String> get adjustTips => _adjustTips ?? const [];
  set adjustTips(List<String>? val) => _adjustTips = val;

  void updateAdjustTips(Function(List<String>) updateFn) {
    updateFn(_adjustTips ??= []);
  }

  bool hasAdjustTips() => _adjustTips != null;

  static WeekAnalyzeDataStruct fromMap(Map<String, dynamic> data) =>
      WeekAnalyzeDataStruct(
        goal: data['goal'] is CpcfStruct
            ? data['goal']
            : CpcfStruct.maybeFromMap(data['goal']),
        average: data['average'] is Cpcf2Struct
            ? data['average']
            : Cpcf2Struct.maybeFromMap(data['average']),
        balance: data['balance'] is Cpcf3Struct
            ? data['balance']
            : Cpcf3Struct.maybeFromMap(data['balance']),
        overage: data['overage'] as String?,
        biggestSources: getDataList(data['biggest_sources']),
        adjustTips: getDataList(data['adjust_tips']),
      );

  static WeekAnalyzeDataStruct? maybeFromMap(dynamic data) => data is Map
      ? WeekAnalyzeDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'goal': _goal?.toMap(),
        'average': _average?.toMap(),
        'balance': _balance?.toMap(),
        'overage': _overage,
        'biggest_sources': _biggestSources,
        'adjust_tips': _adjustTips,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'goal': serializeParam(
          _goal,
          ParamType.DataStruct,
        ),
        'average': serializeParam(
          _average,
          ParamType.DataStruct,
        ),
        'balance': serializeParam(
          _balance,
          ParamType.DataStruct,
        ),
        'overage': serializeParam(
          _overage,
          ParamType.String,
        ),
        'biggest_sources': serializeParam(
          _biggestSources,
          ParamType.String,
          isList: true,
        ),
        'adjust_tips': serializeParam(
          _adjustTips,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static WeekAnalyzeDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      WeekAnalyzeDataStruct(
        goal: deserializeStructParam(
          data['goal'],
          ParamType.DataStruct,
          false,
          structBuilder: CpcfStruct.fromSerializableMap,
        ),
        average: deserializeStructParam(
          data['average'],
          ParamType.DataStruct,
          false,
          structBuilder: Cpcf2Struct.fromSerializableMap,
        ),
        balance: deserializeStructParam(
          data['balance'],
          ParamType.DataStruct,
          false,
          structBuilder: Cpcf3Struct.fromSerializableMap,
        ),
        overage: deserializeParam(
          data['overage'],
          ParamType.String,
          false,
        ),
        biggestSources: deserializeParam<String>(
          data['biggest_sources'],
          ParamType.String,
          true,
        ),
        adjustTips: deserializeParam<String>(
          data['adjust_tips'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'WeekAnalyzeDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is WeekAnalyzeDataStruct &&
        goal == other.goal &&
        average == other.average &&
        balance == other.balance &&
        overage == other.overage &&
        listEquality.equals(biggestSources, other.biggestSources) &&
        listEquality.equals(adjustTips, other.adjustTips);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([goal, average, balance, overage, biggestSources, adjustTips]);
}

WeekAnalyzeDataStruct createWeekAnalyzeDataStruct({
  CpcfStruct? goal,
  Cpcf2Struct? average,
  Cpcf3Struct? balance,
  String? overage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    WeekAnalyzeDataStruct(
      goal: goal ?? (clearUnsetFields ? CpcfStruct() : null),
      average: average ?? (clearUnsetFields ? Cpcf2Struct() : null),
      balance: balance ?? (clearUnsetFields ? Cpcf3Struct() : null),
      overage: overage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

WeekAnalyzeDataStruct? updateWeekAnalyzeDataStruct(
  WeekAnalyzeDataStruct? weekAnalyzeData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    weekAnalyzeData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addWeekAnalyzeDataStructData(
  Map<String, dynamic> firestoreData,
  WeekAnalyzeDataStruct? weekAnalyzeData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (weekAnalyzeData == null) {
    return;
  }
  if (weekAnalyzeData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && weekAnalyzeData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final weekAnalyzeDataData =
      getWeekAnalyzeDataFirestoreData(weekAnalyzeData, forFieldValue);
  final nestedData =
      weekAnalyzeDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = weekAnalyzeData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWeekAnalyzeDataFirestoreData(
  WeekAnalyzeDataStruct? weekAnalyzeData, [
  bool forFieldValue = false,
]) {
  if (weekAnalyzeData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(weekAnalyzeData.toMap());

  // Handle nested data for "goal" field.
  addCpcfStructData(
    firestoreData,
    weekAnalyzeData.hasGoal() ? weekAnalyzeData.goal : null,
    'goal',
    forFieldValue,
  );

  // Handle nested data for "average" field.
  addCpcf2StructData(
    firestoreData,
    weekAnalyzeData.hasAverage() ? weekAnalyzeData.average : null,
    'average',
    forFieldValue,
  );

  // Handle nested data for "balance" field.
  addCpcf3StructData(
    firestoreData,
    weekAnalyzeData.hasBalance() ? weekAnalyzeData.balance : null,
    'balance',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(weekAnalyzeData.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWeekAnalyzeDataListFirestoreData(
  List<WeekAnalyzeDataStruct>? weekAnalyzeDatas,
) =>
    weekAnalyzeDatas
        ?.map((e) => getWeekAnalyzeDataFirestoreData(e, true))
        .toList() ??
    [];

import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddedDishHistoryRecord extends FirestoreRecord {
  AddedDishHistoryRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "dishName" field.
  String? _dishName;
  String get dishName => _dishName ?? '';
  bool hasDishName() => _dishName != null;

  // "dishWeight" field.
  int? _dishWeight;
  int get dishWeight => _dishWeight ?? 0;
  bool hasDishWeight() => _dishWeight != null;

  // "addedDate" field.
  DateTime? _addedDate;
  DateTime? get addedDate => _addedDate;
  bool hasAddedDate() => _addedDate != null;

  // "restaurant" field.
  String? _restaurant;
  String get restaurant => _restaurant ?? '';
  bool hasRestaurant() => _restaurant != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "kcal" field.
  int? _kcal;
  int get kcal => _kcal ?? 0;
  bool hasKcal() => _kcal != null;

  // "carbs" field.
  int? _carbs;
  int get carbs => _carbs ?? 0;
  bool hasCarbs() => _carbs != null;

  // "proteins" field.
  int? _proteins;
  int get proteins => _proteins ?? 0;
  bool hasProteins() => _proteins != null;

  // "fats" field.
  int? _fats;
  int get fats => _fats ?? 0;
  bool hasFats() => _fats != null;

  // "main_ingredients" field.
  List<String>? _mainIngredients;
  List<String> get mainIngredients => _mainIngredients ?? const [];
  bool hasMainIngredients() => _mainIngredients != null;

  // "vitamins" field.
  List<DishPageVitaminsDataStruct>? _vitamins;
  List<DishPageVitaminsDataStruct> get vitamins => _vitamins ?? const [];
  bool hasVitamins() => _vitamins != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "health_tips" field.
  List<String>? _healthTips;
  List<String> get healthTips => _healthTips ?? const [];
  bool hasHealthTips() => _healthTips != null;

  // "roast_text" field.
  String? _roastText;
  String get roastText => _roastText ?? '';
  bool hasRoastText() => _roastText != null;

  // "roast_audio" field.
  String? _roastAudio;
  String get roastAudio => _roastAudio ?? '';
  bool hasRoastAudio() => _roastAudio != null;

  // "roast_person" field.
  String? _roastPerson;
  String get roastPerson => _roastPerson ?? '';
  bool hasRoastPerson() => _roastPerson != null;

  // "roast_voice_id" field.
  String? _roastVoiceId;
  String get roastVoiceId => _roastVoiceId ?? '';
  bool hasRoastVoiceId() => _roastVoiceId != null;

  // "roast_image" field.
  String? _roastImage;
  String get roastImage => _roastImage ?? '';
  bool hasRoastImage() => _roastImage != null;

  // "roastLevel" field.
  String? _roastLevel;
  String get roastLevel => _roastLevel ?? '';
  bool hasRoastLevel() => _roastLevel != null;

  // "badge" field.
  String? _badge;
  String get badge => _badge ?? '';
  bool hasBadge() => _badge != null;

  // "impact" field.
  String? _impact;
  String get impact => _impact ?? '';
  bool hasImpact() => _impact != null;

  // "calorieshare" field.
  String? _calorieshare;
  String get calorieshare => _calorieshare ?? '';
  bool hasCalorieshare() => _calorieshare != null;

  // "roast_mode" field.
  String? _roastMode;
  String get roastMode => _roastMode ?? '';
  bool hasRoastMode() => _roastMode != null;

  // "occasion_key" field.
  String? _occasionKey;
  String get occasionKey => _occasionKey ?? '';
  bool hasOccasionKey() => _occasionKey != null;

  // "occasion_label" field.
  String? _occasionLabel;
  String get occasionLabel => _occasionLabel ?? '';
  bool hasOccasionLabel() => _occasionLabel != null;

  // "subject_type" field.
  String? _subjectType;
  String get subjectType => _subjectType ?? '';
  bool hasSubjectType() => _subjectType != null;

  // "show_nutrition" field.
  bool? _showNutrition;
  bool get showNutrition => _showNutrition ?? false;
  bool hasShowNutrition() => _showNutrition != null;

  void _initializeFields() {
    _dishName = snapshotData['dishName'] as String?;
    _dishWeight = castToType<int>(snapshotData['dishWeight']);
    _addedDate = snapshotData['addedDate'] as DateTime?;
    _restaurant = snapshotData['restaurant'] as String?;
    _image = snapshotData['image'] as String?;
    _kcal = castToType<int>(snapshotData['kcal']);
    _carbs = castToType<int>(snapshotData['carbs']);
    _proteins = castToType<int>(snapshotData['proteins']);
    _fats = castToType<int>(snapshotData['fats']);
    _mainIngredients = getDataList(snapshotData['main_ingredients']);
    _vitamins = getStructList(
      snapshotData['vitamins'],
      DishPageVitaminsDataStruct.fromMap,
    );
    _user = snapshotData['user'] as DocumentReference?;
    _healthTips = getDataList(snapshotData['health_tips']);
    _roastText = snapshotData['roast_text'] as String?;
    _roastAudio = snapshotData['roast_audio'] as String?;
    _roastPerson = snapshotData['roast_person'] as String?;
    _roastVoiceId = snapshotData['roast_voice_id'] as String?;
    _roastImage = snapshotData['roast_image'] as String?;
    _roastLevel = snapshotData['roastLevel'] as String?;
    _badge = snapshotData['badge'] as String?;
    _impact = snapshotData['impact'] as String?;
    _calorieshare = snapshotData['calorieshare'] as String?;
    _roastMode = snapshotData['roast_mode'] as String?;
    _occasionKey = snapshotData['occasion_key'] as String?;
    _occasionLabel = snapshotData['occasion_label'] as String?;
    _subjectType = snapshotData['subject_type'] as String?;
    _showNutrition = snapshotData['show_nutrition'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('AddedDishHistory');

  static Stream<AddedDishHistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AddedDishHistoryRecord.fromSnapshot(s));

  static Future<AddedDishHistoryRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AddedDishHistoryRecord.fromSnapshot(s));

  static AddedDishHistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AddedDishHistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AddedDishHistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AddedDishHistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AddedDishHistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AddedDishHistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAddedDishHistoryRecordData({
  String? dishName,
  int? dishWeight,
  DateTime? addedDate,
  String? restaurant,
  String? image,
  int? kcal,
  int? carbs,
  int? proteins,
  int? fats,
  DocumentReference? user,
  String? roastText,
  String? roastAudio,
  String? roastPerson,
  String? roastVoiceId,
  String? roastImage,
  String? roastLevel,
  String? badge,
  String? impact,
  String? calorieshare,
  String? roastMode,
  String? occasionKey,
  String? occasionLabel,
  String? subjectType,
  bool? showNutrition,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'dishName': dishName,
      'dishWeight': dishWeight,
      'addedDate': addedDate,
      'restaurant': restaurant,
      'image': image,
      'kcal': kcal,
      'carbs': carbs,
      'proteins': proteins,
      'fats': fats,
      'user': user,
      'roast_text': roastText,
      'roast_audio': roastAudio,
      'roast_person': roastPerson,
      'roast_voice_id': roastVoiceId,
      'roast_image': roastImage,
      'roastLevel': roastLevel,
      'badge': badge,
      'impact': impact,
      'calorieshare': calorieshare,
      'roast_mode': roastMode,
      'occasion_key': occasionKey,
      'occasion_label': occasionLabel,
      'subject_type': subjectType,
      'show_nutrition': showNutrition,
    }.withoutNulls,
  );

  return firestoreData;
}

class AddedDishHistoryRecordDocumentEquality
    implements Equality<AddedDishHistoryRecord> {
  const AddedDishHistoryRecordDocumentEquality();

  @override
  bool equals(AddedDishHistoryRecord? e1, AddedDishHistoryRecord? e2) {
    const listEquality = ListEquality();
    return e1?.dishName == e2?.dishName &&
        e1?.dishWeight == e2?.dishWeight &&
        e1?.addedDate == e2?.addedDate &&
        e1?.restaurant == e2?.restaurant &&
        e1?.image == e2?.image &&
        e1?.kcal == e2?.kcal &&
        e1?.carbs == e2?.carbs &&
        e1?.proteins == e2?.proteins &&
        e1?.fats == e2?.fats &&
        listEquality.equals(e1?.mainIngredients, e2?.mainIngredients) &&
        listEquality.equals(e1?.vitamins, e2?.vitamins) &&
        e1?.user == e2?.user &&
        listEquality.equals(e1?.healthTips, e2?.healthTips) &&
        e1?.roastText == e2?.roastText &&
        e1?.roastAudio == e2?.roastAudio &&
        e1?.roastPerson == e2?.roastPerson &&
        e1?.roastVoiceId == e2?.roastVoiceId &&
        e1?.roastImage == e2?.roastImage &&
        e1?.roastLevel == e2?.roastLevel &&
        e1?.badge == e2?.badge &&
        e1?.impact == e2?.impact &&
        e1?.calorieshare == e2?.calorieshare &&
        e1?.roastMode == e2?.roastMode &&
        e1?.occasionKey == e2?.occasionKey &&
        e1?.occasionLabel == e2?.occasionLabel &&
        e1?.subjectType == e2?.subjectType &&
        e1?.showNutrition == e2?.showNutrition;
  }

  @override
  int hash(AddedDishHistoryRecord? e) => const ListEquality().hash([
        e?.dishName,
        e?.dishWeight,
        e?.addedDate,
        e?.restaurant,
        e?.image,
        e?.kcal,
        e?.carbs,
        e?.proteins,
        e?.fats,
        e?.mainIngredients,
        e?.vitamins,
        e?.user,
        e?.healthTips,
        e?.roastText,
        e?.roastAudio,
        e?.roastPerson,
        e?.roastVoiceId,
        e?.roastImage,
        e?.roastLevel,
        e?.badge,
        e?.impact,
        e?.calorieshare,
        e?.roastMode,
        e?.occasionKey,
        e?.occasionLabel,
        e?.subjectType,
        e?.showNutrition
      ]);

  @override
  bool isValidKey(Object? o) => o is AddedDishHistoryRecord;
}

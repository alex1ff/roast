import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  bool hasAge() => _age != null;

  // "kcal_goal" field.
  int? _kcalGoal;
  int get kcalGoal => _kcalGoal ?? 0;
  bool hasKcalGoal() => _kcalGoal != null;

  // "carbs_goal" field.
  int? _carbsGoal;
  int get carbsGoal => _carbsGoal ?? 0;
  bool hasCarbsGoal() => _carbsGoal != null;

  // "fats_goal" field.
  int? _fatsGoal;
  int get fatsGoal => _fatsGoal ?? 0;
  bool hasFatsGoal() => _fatsGoal != null;

  // "proteins_goal" field.
  int? _proteinsGoal;
  int get proteinsGoal => _proteinsGoal ?? 0;
  bool hasProteinsGoal() => _proteinsGoal != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "activity_level" field.
  String? _activityLevel;
  String get activityLevel => _activityLevel ?? '';
  bool hasActivityLevel() => _activityLevel != null;

  // "sugarFree" field.
  bool? _sugarFree;
  bool get sugarFree => _sugarFree ?? false;
  bool hasSugarFree() => _sugarFree != null;

  // "glutenFree" field.
  bool? _glutenFree;
  bool get glutenFree => _glutenFree ?? false;
  bool hasGlutenFree() => _glutenFree != null;

  // "dairyEater" field.
  bool? _dairyEater;
  bool get dairyEater => _dairyEater ?? false;
  bool hasDairyEater() => _dairyEater != null;

  // "meatEater" field.
  bool? _meatEater;
  bool get meatEater => _meatEater ?? false;
  bool hasMeatEater() => _meatEater != null;

  // "halal" field.
  bool? _halal;
  bool get halal => _halal ?? false;
  bool hasHalal() => _halal != null;

  // "measurementOz" field.
  bool? _measurementOz;
  bool get measurementOz => _measurementOz ?? false;
  bool hasMeasurementOz() => _measurementOz != null;

  // "weight" field.
  double? _weight;
  double get weight => _weight ?? 0.0;
  bool hasWeight() => _weight != null;

  // "highMeasurementFt" field.
  bool? _highMeasurementFt;
  bool get highMeasurementFt => _highMeasurementFt ?? false;
  bool hasHighMeasurementFt() => _highMeasurementFt != null;

  // "user_goal" field.
  String? _userGoal;
  String get userGoal => _userGoal ?? '';
  bool hasUserGoal() => _userGoal != null;

  // "height" field.
  double? _height;
  double get height => _height ?? 0.0;
  bool hasHeight() => _height != null;

  // "invited_code" field.
  String? _invitedCode;
  String get invitedCode => _invitedCode ?? '';
  bool hasInvitedCode() => _invitedCode != null;

  // "count_limited" field.
  int? _countLimited;
  int get countLimited => _countLimited ?? 0;
  bool hasCountLimited() => _countLimited != null;

  // "count_limited_chat" field.
  int? _countLimitedChat;
  int get countLimitedChat => _countLimitedChat ?? 0;
  bool hasCountLimitedChat() => _countLimitedChat != null;

  // "voice_id" field.
  String? _voiceId;
  String get voiceId => _voiceId ?? '';
  bool hasVoiceId() => _voiceId != null;

  // "voice_name" field.
  String? _voiceName;
  String get voiceName => _voiceName ?? '';
  bool hasVoiceName() => _voiceName != null;

  // "roastLevel" field.
  String? _roastLevel;
  String get roastLevel => _roastLevel ?? '';
  bool hasRoastLevel() => _roastLevel != null;

  // "first_login" field.
  bool? _firstLogin;
  bool get firstLogin => _firstLogin ?? false;
  bool hasFirstLogin() => _firstLogin != null;

  // "dateSubStart" field.
  DateTime? _dateSubStart;
  DateTime? get dateSubStart => _dateSubStart;
  bool hasDateSubStart() => _dateSubStart != null;

  // "dateSubEnd" field.
  DateTime? _dateSubEnd;
  DateTime? get dateSubEnd => _dateSubEnd;
  bool hasDateSubEnd() => _dateSubEnd != null;

  // "SubPlan" field.
  SubPlan? _subPlan;
  SubPlan? get subPlan => _subPlan;
  bool hasSubPlan() => _subPlan != null;

  // "extra_chat" field.
  int? _extraChat;
  int get extraChat => _extraChat ?? 0;
  bool hasExtraChat() => _extraChat != null;

  // "extra_photo" field.
  int? _extraPhoto;
  int get extraPhoto => _extraPhoto ?? 0;
  bool hasExtraPhoto() => _extraPhoto != null;

  // "extra_nophoto" field.
  int? _extraNophoto;
  int get extraNophoto => _extraNophoto ?? 0;
  bool hasExtraNophoto() => _extraNophoto != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _age = castToType<int>(snapshotData['age']);
    _kcalGoal = castToType<int>(snapshotData['kcal_goal']);
    _carbsGoal = castToType<int>(snapshotData['carbs_goal']);
    _fatsGoal = castToType<int>(snapshotData['fats_goal']);
    _proteinsGoal = castToType<int>(snapshotData['proteins_goal']);
    _gender = snapshotData['gender'] as String?;
    _activityLevel = snapshotData['activity_level'] as String?;
    _sugarFree = snapshotData['sugarFree'] as bool?;
    _glutenFree = snapshotData['glutenFree'] as bool?;
    _dairyEater = snapshotData['dairyEater'] as bool?;
    _meatEater = snapshotData['meatEater'] as bool?;
    _halal = snapshotData['halal'] as bool?;
    _measurementOz = snapshotData['measurementOz'] as bool?;
    _weight = castToType<double>(snapshotData['weight']);
    _highMeasurementFt = snapshotData['highMeasurementFt'] as bool?;
    _userGoal = snapshotData['user_goal'] as String?;
    _height = castToType<double>(snapshotData['height']);
    _invitedCode = snapshotData['invited_code'] as String?;
    _countLimited = castToType<int>(snapshotData['count_limited']);
    _countLimitedChat = castToType<int>(snapshotData['count_limited_chat']);
    _voiceId = snapshotData['voice_id'] as String?;
    _voiceName = snapshotData['voice_name'] as String?;
    _roastLevel = snapshotData['roastLevel'] as String?;
    _firstLogin = snapshotData['first_login'] as bool?;
    _dateSubStart = snapshotData['dateSubStart'] as DateTime?;
    _dateSubEnd = snapshotData['dateSubEnd'] as DateTime?;
    _subPlan = snapshotData['SubPlan'] is SubPlan
        ? snapshotData['SubPlan']
        : deserializeEnum<SubPlan>(snapshotData['SubPlan']);
    _extraChat = castToType<int>(snapshotData['extra_chat']);
    _extraPhoto = castToType<int>(snapshotData['extra_photo']);
    _extraNophoto = castToType<int>(snapshotData['extra_nophoto']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  int? age,
  int? kcalGoal,
  int? carbsGoal,
  int? fatsGoal,
  int? proteinsGoal,
  String? gender,
  String? activityLevel,
  bool? sugarFree,
  bool? glutenFree,
  bool? dairyEater,
  bool? meatEater,
  bool? halal,
  bool? measurementOz,
  double? weight,
  bool? highMeasurementFt,
  String? userGoal,
  double? height,
  String? invitedCode,
  int? countLimited,
  int? countLimitedChat,
  String? voiceId,
  String? voiceName,
  String? roastLevel,
  bool? firstLogin,
  DateTime? dateSubStart,
  DateTime? dateSubEnd,
  SubPlan? subPlan,
  int? extraChat,
  int? extraPhoto,
  int? extraNophoto,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'age': age,
      'kcal_goal': kcalGoal,
      'carbs_goal': carbsGoal,
      'fats_goal': fatsGoal,
      'proteins_goal': proteinsGoal,
      'gender': gender,
      'activity_level': activityLevel,
      'sugarFree': sugarFree,
      'glutenFree': glutenFree,
      'dairyEater': dairyEater,
      'meatEater': meatEater,
      'halal': halal,
      'measurementOz': measurementOz,
      'weight': weight,
      'highMeasurementFt': highMeasurementFt,
      'user_goal': userGoal,
      'height': height,
      'invited_code': invitedCode,
      'count_limited': countLimited,
      'count_limited_chat': countLimitedChat,
      'voice_id': voiceId,
      'voice_name': voiceName,
      'roastLevel': roastLevel,
      'first_login': firstLogin,
      'dateSubStart': dateSubStart,
      'dateSubEnd': dateSubEnd,
      'SubPlan': subPlan,
      'extra_chat': extraChat,
      'extra_photo': extraPhoto,
      'extra_nophoto': extraNophoto,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.age == e2?.age &&
        e1?.kcalGoal == e2?.kcalGoal &&
        e1?.carbsGoal == e2?.carbsGoal &&
        e1?.fatsGoal == e2?.fatsGoal &&
        e1?.proteinsGoal == e2?.proteinsGoal &&
        e1?.gender == e2?.gender &&
        e1?.activityLevel == e2?.activityLevel &&
        e1?.sugarFree == e2?.sugarFree &&
        e1?.glutenFree == e2?.glutenFree &&
        e1?.dairyEater == e2?.dairyEater &&
        e1?.meatEater == e2?.meatEater &&
        e1?.halal == e2?.halal &&
        e1?.measurementOz == e2?.measurementOz &&
        e1?.weight == e2?.weight &&
        e1?.highMeasurementFt == e2?.highMeasurementFt &&
        e1?.userGoal == e2?.userGoal &&
        e1?.height == e2?.height &&
        e1?.invitedCode == e2?.invitedCode &&
        e1?.countLimited == e2?.countLimited &&
        e1?.countLimitedChat == e2?.countLimitedChat &&
        e1?.voiceId == e2?.voiceId &&
        e1?.voiceName == e2?.voiceName &&
        e1?.roastLevel == e2?.roastLevel &&
        e1?.firstLogin == e2?.firstLogin &&
        e1?.dateSubStart == e2?.dateSubStart &&
        e1?.dateSubEnd == e2?.dateSubEnd &&
        e1?.subPlan == e2?.subPlan &&
        e1?.extraChat == e2?.extraChat &&
        e1?.extraPhoto == e2?.extraPhoto &&
        e1?.extraNophoto == e2?.extraNophoto;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.age,
        e?.kcalGoal,
        e?.carbsGoal,
        e?.fatsGoal,
        e?.proteinsGoal,
        e?.gender,
        e?.activityLevel,
        e?.sugarFree,
        e?.glutenFree,
        e?.dairyEater,
        e?.meatEater,
        e?.halal,
        e?.measurementOz,
        e?.weight,
        e?.highMeasurementFt,
        e?.userGoal,
        e?.height,
        e?.invitedCode,
        e?.countLimited,
        e?.countLimitedChat,
        e?.voiceId,
        e?.voiceName,
        e?.roastLevel,
        e?.firstLogin,
        e?.dateSubStart,
        e?.dateSubEnd,
        e?.subPlan,
        e?.extraChat,
        e?.extraPhoto,
        e?.extraNophoto
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}

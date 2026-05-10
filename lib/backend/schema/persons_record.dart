import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PersonsRecord extends FirestoreRecord {
  PersonsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "voice_id" field.
  String? _voiceId;
  String get voiceId => _voiceId ?? '';
  bool hasVoiceId() => _voiceId != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _voiceId = snapshotData['voice_id'] as String?;
    _image = snapshotData['image'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('persons');

  static Stream<PersonsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PersonsRecord.fromSnapshot(s));

  static Future<PersonsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PersonsRecord.fromSnapshot(s));

  static PersonsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PersonsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PersonsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PersonsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PersonsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PersonsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPersonsRecordData({
  String? name,
  String? voiceId,
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'voice_id': voiceId,
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class PersonsRecordDocumentEquality implements Equality<PersonsRecord> {
  const PersonsRecordDocumentEquality();

  @override
  bool equals(PersonsRecord? e1, PersonsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.voiceId == e2?.voiceId &&
        e1?.image == e2?.image;
  }

  @override
  int hash(PersonsRecord? e) =>
      const ListEquality().hash([e?.name, e?.voiceId, e?.image]);

  @override
  bool isValidKey(Object? o) => o is PersonsRecord;
}

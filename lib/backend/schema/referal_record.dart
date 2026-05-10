import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReferalRecord extends FirestoreRecord {
  ReferalRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "invited_user" field.
  DocumentReference? _invitedUser;
  DocumentReference? get invitedUser => _invitedUser;
  bool hasInvitedUser() => _invitedUser != null;

  // "code_author" field.
  DocumentReference? _codeAuthor;
  DocumentReference? get codeAuthor => _codeAuthor;
  bool hasCodeAuthor() => _codeAuthor != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  void _initializeFields() {
    _invitedUser = snapshotData['invited_user'] as DocumentReference?;
    _codeAuthor = snapshotData['code_author'] as DocumentReference?;
    _date = snapshotData['date'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Referal');

  static Stream<ReferalRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReferalRecord.fromSnapshot(s));

  static Future<ReferalRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReferalRecord.fromSnapshot(s));

  static ReferalRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReferalRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReferalRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReferalRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReferalRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReferalRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReferalRecordData({
  DocumentReference? invitedUser,
  DocumentReference? codeAuthor,
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'invited_user': invitedUser,
      'code_author': codeAuthor,
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReferalRecordDocumentEquality implements Equality<ReferalRecord> {
  const ReferalRecordDocumentEquality();

  @override
  bool equals(ReferalRecord? e1, ReferalRecord? e2) {
    return e1?.invitedUser == e2?.invitedUser &&
        e1?.codeAuthor == e2?.codeAuthor &&
        e1?.date == e2?.date;
  }

  @override
  int hash(ReferalRecord? e) =>
      const ListEquality().hash([e?.invitedUser, e?.codeAuthor, e?.date]);

  @override
  bool isValidKey(Object? o) => o is ReferalRecord;
}

// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DishPageDataStruct extends FFFirebaseStruct {
  DishPageDataStruct({
    String? dishName,
    int? dishWeight,
    String? restaurant,
    String? image,
    List<String>? mainIngredients,
    int? kcalDish,
    int? carbs,
    int? fats,
    int? proteins,
    List<DishPageVitaminsDataStruct>? vitamins,
    List<String>? healthTips,
    String? dishNameRu,
    List<String>? mainIngredientsRu,
    List<DishPageVitaminsDataStruct>? vitaminsRu,
    List<String>? healthTipsRu,
    DocumentReference? dishLink,
    String? voiceCharacter,
    String? voiceId,
    String? roastText,
    String? roastAudio,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _dishName = dishName,
        _dishWeight = dishWeight,
        _restaurant = restaurant,
        _image = image,
        _mainIngredients = mainIngredients,
        _kcalDish = kcalDish,
        _carbs = carbs,
        _fats = fats,
        _proteins = proteins,
        _vitamins = vitamins,
        _healthTips = healthTips,
        _dishNameRu = dishNameRu,
        _mainIngredientsRu = mainIngredientsRu,
        _vitaminsRu = vitaminsRu,
        _healthTipsRu = healthTipsRu,
        _dishLink = dishLink,
        _voiceCharacter = voiceCharacter,
        _voiceId = voiceId,
        _roastText = roastText,
        _roastAudio = roastAudio,
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

  // "restaurant" field.
  String? _restaurant;
  String get restaurant => _restaurant ?? '';
  set restaurant(String? val) => _restaurant = val;

  bool hasRestaurant() => _restaurant != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "main_ingredients" field.
  List<String>? _mainIngredients;
  List<String> get mainIngredients => _mainIngredients ?? const [];
  set mainIngredients(List<String>? val) => _mainIngredients = val;

  void updateMainIngredients(Function(List<String>) updateFn) {
    updateFn(_mainIngredients ??= []);
  }

  bool hasMainIngredients() => _mainIngredients != null;

  // "kcal_dish" field.
  int? _kcalDish;
  int get kcalDish => _kcalDish ?? 0;
  set kcalDish(int? val) => _kcalDish = val;

  void incrementKcalDish(int amount) => kcalDish = kcalDish + amount;

  bool hasKcalDish() => _kcalDish != null;

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

  // "proteins" field.
  int? _proteins;
  int get proteins => _proteins ?? 0;
  set proteins(int? val) => _proteins = val;

  void incrementProteins(int amount) => proteins = proteins + amount;

  bool hasProteins() => _proteins != null;

  // "vitamins" field.
  List<DishPageVitaminsDataStruct>? _vitamins;
  List<DishPageVitaminsDataStruct> get vitamins => _vitamins ?? const [];
  set vitamins(List<DishPageVitaminsDataStruct>? val) => _vitamins = val;

  void updateVitamins(Function(List<DishPageVitaminsDataStruct>) updateFn) {
    updateFn(_vitamins ??= []);
  }

  bool hasVitamins() => _vitamins != null;

  // "health_tips" field.
  List<String>? _healthTips;
  List<String> get healthTips => _healthTips ?? const [];
  set healthTips(List<String>? val) => _healthTips = val;

  void updateHealthTips(Function(List<String>) updateFn) {
    updateFn(_healthTips ??= []);
  }

  bool hasHealthTips() => _healthTips != null;

  // "dishName_ru" field.
  String? _dishNameRu;
  String get dishNameRu => _dishNameRu ?? '';
  set dishNameRu(String? val) => _dishNameRu = val;

  bool hasDishNameRu() => _dishNameRu != null;

  // "main_ingredients_ru" field.
  List<String>? _mainIngredientsRu;
  List<String> get mainIngredientsRu => _mainIngredientsRu ?? const [];
  set mainIngredientsRu(List<String>? val) => _mainIngredientsRu = val;

  void updateMainIngredientsRu(Function(List<String>) updateFn) {
    updateFn(_mainIngredientsRu ??= []);
  }

  bool hasMainIngredientsRu() => _mainIngredientsRu != null;

  // "vitamins_ru" field.
  List<DishPageVitaminsDataStruct>? _vitaminsRu;
  List<DishPageVitaminsDataStruct> get vitaminsRu => _vitaminsRu ?? const [];
  set vitaminsRu(List<DishPageVitaminsDataStruct>? val) => _vitaminsRu = val;

  void updateVitaminsRu(Function(List<DishPageVitaminsDataStruct>) updateFn) {
    updateFn(_vitaminsRu ??= []);
  }

  bool hasVitaminsRu() => _vitaminsRu != null;

  // "health_tips_ru" field.
  List<String>? _healthTipsRu;
  List<String> get healthTipsRu => _healthTipsRu ?? const [];
  set healthTipsRu(List<String>? val) => _healthTipsRu = val;

  void updateHealthTipsRu(Function(List<String>) updateFn) {
    updateFn(_healthTipsRu ??= []);
  }

  bool hasHealthTipsRu() => _healthTipsRu != null;

  // "dishLink" field.
  DocumentReference? _dishLink;
  DocumentReference? get dishLink => _dishLink;
  set dishLink(DocumentReference? val) => _dishLink = val;

  bool hasDishLink() => _dishLink != null;

  // "voice_character" field.
  String? _voiceCharacter;
  String get voiceCharacter => _voiceCharacter ?? '';
  set voiceCharacter(String? val) => _voiceCharacter = val;

  bool hasVoiceCharacter() => _voiceCharacter != null;

  // "voice_id" field.
  String? _voiceId;
  String get voiceId => _voiceId ?? '';
  set voiceId(String? val) => _voiceId = val;

  bool hasVoiceId() => _voiceId != null;

  // "roast_text" field.
  String? _roastText;
  String get roastText => _roastText ?? '';
  set roastText(String? val) => _roastText = val;

  bool hasRoastText() => _roastText != null;

  // "roast_audio" field.
  String? _roastAudio;
  String get roastAudio => _roastAudio ?? '';
  set roastAudio(String? val) => _roastAudio = val;

  bool hasRoastAudio() => _roastAudio != null;

  static DishPageDataStruct fromMap(Map<String, dynamic> data) =>
      DishPageDataStruct(
        dishName: data['dish_name'] as String?,
        dishWeight: castToType<int>(data['dish_weight']),
        restaurant: data['restaurant'] as String?,
        image: data['image'] as String?,
        mainIngredients: getDataList(data['main_ingredients']),
        kcalDish: castToType<int>(data['kcal_dish']),
        carbs: castToType<int>(data['carbs']),
        fats: castToType<int>(data['fats']),
        proteins: castToType<int>(data['proteins']),
        vitamins: getStructList(
          data['vitamins'],
          DishPageVitaminsDataStruct.fromMap,
        ),
        healthTips: getDataList(data['health_tips']),
        dishNameRu: data['dishName_ru'] as String?,
        mainIngredientsRu: getDataList(data['main_ingredients_ru']),
        vitaminsRu: getStructList(
          data['vitamins_ru'],
          DishPageVitaminsDataStruct.fromMap,
        ),
        healthTipsRu: getDataList(data['health_tips_ru']),
        dishLink: data['dishLink'] as DocumentReference?,
        voiceCharacter: data['voice_character'] as String?,
        voiceId: data['voice_id'] as String?,
        roastText: data['roast_text'] as String?,
        roastAudio: data['roast_audio'] as String?,
      );

  static DishPageDataStruct? maybeFromMap(dynamic data) => data is Map
      ? DishPageDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dish_name': _dishName,
        'dish_weight': _dishWeight,
        'restaurant': _restaurant,
        'image': _image,
        'main_ingredients': _mainIngredients,
        'kcal_dish': _kcalDish,
        'carbs': _carbs,
        'fats': _fats,
        'proteins': _proteins,
        'vitamins': _vitamins?.map((e) => e.toMap()).toList(),
        'health_tips': _healthTips,
        'dishName_ru': _dishNameRu,
        'main_ingredients_ru': _mainIngredientsRu,
        'vitamins_ru': _vitaminsRu?.map((e) => e.toMap()).toList(),
        'health_tips_ru': _healthTipsRu,
        'dishLink': _dishLink,
        'voice_character': _voiceCharacter,
        'voice_id': _voiceId,
        'roast_text': _roastText,
        'roast_audio': _roastAudio,
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
        'restaurant': serializeParam(
          _restaurant,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'main_ingredients': serializeParam(
          _mainIngredients,
          ParamType.String,
          isList: true,
        ),
        'kcal_dish': serializeParam(
          _kcalDish,
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
        'proteins': serializeParam(
          _proteins,
          ParamType.int,
        ),
        'vitamins': serializeParam(
          _vitamins,
          ParamType.DataStruct,
          isList: true,
        ),
        'health_tips': serializeParam(
          _healthTips,
          ParamType.String,
          isList: true,
        ),
        'dishName_ru': serializeParam(
          _dishNameRu,
          ParamType.String,
        ),
        'main_ingredients_ru': serializeParam(
          _mainIngredientsRu,
          ParamType.String,
          isList: true,
        ),
        'vitamins_ru': serializeParam(
          _vitaminsRu,
          ParamType.DataStruct,
          isList: true,
        ),
        'health_tips_ru': serializeParam(
          _healthTipsRu,
          ParamType.String,
          isList: true,
        ),
        'dishLink': serializeParam(
          _dishLink,
          ParamType.DocumentReference,
        ),
        'voice_character': serializeParam(
          _voiceCharacter,
          ParamType.String,
        ),
        'voice_id': serializeParam(
          _voiceId,
          ParamType.String,
        ),
        'roast_text': serializeParam(
          _roastText,
          ParamType.String,
        ),
        'roast_audio': serializeParam(
          _roastAudio,
          ParamType.String,
        ),
      }.withoutNulls;

  static DishPageDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      DishPageDataStruct(
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
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        mainIngredients: deserializeParam<String>(
          data['main_ingredients'],
          ParamType.String,
          true,
        ),
        kcalDish: deserializeParam(
          data['kcal_dish'],
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
        proteins: deserializeParam(
          data['proteins'],
          ParamType.int,
          false,
        ),
        vitamins: deserializeStructParam<DishPageVitaminsDataStruct>(
          data['vitamins'],
          ParamType.DataStruct,
          true,
          structBuilder: DishPageVitaminsDataStruct.fromSerializableMap,
        ),
        healthTips: deserializeParam<String>(
          data['health_tips'],
          ParamType.String,
          true,
        ),
        dishNameRu: deserializeParam(
          data['dishName_ru'],
          ParamType.String,
          false,
        ),
        mainIngredientsRu: deserializeParam<String>(
          data['main_ingredients_ru'],
          ParamType.String,
          true,
        ),
        vitaminsRu: deserializeStructParam<DishPageVitaminsDataStruct>(
          data['vitamins_ru'],
          ParamType.DataStruct,
          true,
          structBuilder: DishPageVitaminsDataStruct.fromSerializableMap,
        ),
        healthTipsRu: deserializeParam<String>(
          data['health_tips_ru'],
          ParamType.String,
          true,
        ),
        dishLink: deserializeParam(
          data['dishLink'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['AddedDishHistory'],
        ),
        voiceCharacter: deserializeParam(
          data['voice_character'],
          ParamType.String,
          false,
        ),
        voiceId: deserializeParam(
          data['voice_id'],
          ParamType.String,
          false,
        ),
        roastText: deserializeParam(
          data['roast_text'],
          ParamType.String,
          false,
        ),
        roastAudio: deserializeParam(
          data['roast_audio'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DishPageDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DishPageDataStruct &&
        dishName == other.dishName &&
        dishWeight == other.dishWeight &&
        restaurant == other.restaurant &&
        image == other.image &&
        listEquality.equals(mainIngredients, other.mainIngredients) &&
        kcalDish == other.kcalDish &&
        carbs == other.carbs &&
        fats == other.fats &&
        proteins == other.proteins &&
        listEquality.equals(vitamins, other.vitamins) &&
        listEquality.equals(healthTips, other.healthTips) &&
        dishNameRu == other.dishNameRu &&
        listEquality.equals(mainIngredientsRu, other.mainIngredientsRu) &&
        listEquality.equals(vitaminsRu, other.vitaminsRu) &&
        listEquality.equals(healthTipsRu, other.healthTipsRu) &&
        dishLink == other.dishLink &&
        voiceCharacter == other.voiceCharacter &&
        voiceId == other.voiceId &&
        roastText == other.roastText &&
        roastAudio == other.roastAudio;
  }

  @override
  int get hashCode => const ListEquality().hash([
        dishName,
        dishWeight,
        restaurant,
        image,
        mainIngredients,
        kcalDish,
        carbs,
        fats,
        proteins,
        vitamins,
        healthTips,
        dishNameRu,
        mainIngredientsRu,
        vitaminsRu,
        healthTipsRu,
        dishLink,
        voiceCharacter,
        voiceId,
        roastText,
        roastAudio
      ]);
}

DishPageDataStruct createDishPageDataStruct({
  String? dishName,
  int? dishWeight,
  String? restaurant,
  String? image,
  int? kcalDish,
  int? carbs,
  int? fats,
  int? proteins,
  String? dishNameRu,
  DocumentReference? dishLink,
  String? voiceCharacter,
  String? voiceId,
  String? roastText,
  String? roastAudio,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DishPageDataStruct(
      dishName: dishName,
      dishWeight: dishWeight,
      restaurant: restaurant,
      image: image,
      kcalDish: kcalDish,
      carbs: carbs,
      fats: fats,
      proteins: proteins,
      dishNameRu: dishNameRu,
      dishLink: dishLink,
      voiceCharacter: voiceCharacter,
      voiceId: voiceId,
      roastText: roastText,
      roastAudio: roastAudio,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DishPageDataStruct? updateDishPageDataStruct(
  DishPageDataStruct? dishPageData, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dishPageData
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDishPageDataStructData(
  Map<String, dynamic> firestoreData,
  DishPageDataStruct? dishPageData,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dishPageData == null) {
    return;
  }
  if (dishPageData.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dishPageData.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dishPageDataData =
      getDishPageDataFirestoreData(dishPageData, forFieldValue);
  final nestedData =
      dishPageDataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dishPageData.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDishPageDataFirestoreData(
  DishPageDataStruct? dishPageData, [
  bool forFieldValue = false,
]) {
  if (dishPageData == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dishPageData.toMap());

  // Add any Firestore field values
  mapToFirestore(dishPageData.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDishPageDataListFirestoreData(
  List<DishPageDataStruct>? dishPageDatas,
) =>
    dishPageDatas?.map((e) => getDishPageDataFirestoreData(e, true)).toList() ??
    [];

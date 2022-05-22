// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetMatchCollection on Isar {
  IsarCollection<Match> get matchs => getCollection();
}

const MatchSchema = CollectionSchema(
  name: 'Match',
  schema:
      '{"name":"Match","idName":"id","properties":[{"name":"bio","type":"String"},{"name":"displayName","type":"String"},{"name":"gender","type":"String"},{"name":"interests","type":"StringList"},{"name":"pronouns","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'bio': 0,
    'displayName': 1,
    'gender': 2,
    'interests': 3,
    'pronouns': 4
  },
  listProperties: {'interests'},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _matchGetId,
  getLinks: _matchGetLinks,
  attachLinks: _matchAttachLinks,
  serializeNative: _matchSerializeNative,
  deserializeNative: _matchDeserializeNative,
  deserializePropNative: _matchDeserializePropNative,
  serializeWeb: _matchSerializeWeb,
  deserializeWeb: _matchDeserializeWeb,
  deserializePropWeb: _matchDeserializePropWeb,
  version: 3,
);

int? _matchGetId(Match object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

List<IsarLinkBase> _matchGetLinks(Match object) {
  return [];
}

void _matchSerializeNative(
    IsarCollection<Match> collection,
    IsarRawObject rawObj,
    Match object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.bio;
  final _bio = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_bio.length) as int;
  final value1 = object.displayName;
  final _displayName = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_displayName.length) as int;
  final value2 = object.gender;
  IsarUint8List? _gender;
  if (value2 != null) {
    _gender = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_gender?.length ?? 0) as int;
  final value3 = object.interests;
  dynamicSize += (value3.length) * 8;
  final bytesList3 = <IsarUint8List>[];
  for (var str in value3) {
    final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
    bytesList3.add(bytes);
    dynamicSize += bytes.length as int;
  }
  final _interests = bytesList3;
  final value4 = object.pronouns;
  IsarUint8List? _pronouns;
  if (value4 != null) {
    _pronouns = IsarBinaryWriter.utf8Encoder.convert(value4);
  }
  dynamicSize += (_pronouns?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _bio);
  writer.writeBytes(offsets[1], _displayName);
  writer.writeBytes(offsets[2], _gender);
  writer.writeStringList(offsets[3], _interests);
  writer.writeBytes(offsets[4], _pronouns);
}

Match _matchDeserializeNative(IsarCollection<Match> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Match(
    bio: reader.readString(offsets[0]),
    displayName: reader.readString(offsets[1]),
    gender: reader.readStringOrNull(offsets[2]),
    id: id,
    interests: reader.readStringList(offsets[3]) ?? [],
    pronouns: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _matchDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _matchSerializeWeb(IsarCollection<Match> collection, Match object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'bio', object.bio);
  IsarNative.jsObjectSet(jsObj, 'displayName', object.displayName);
  IsarNative.jsObjectSet(jsObj, 'gender', object.gender);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'interests', object.interests);
  IsarNative.jsObjectSet(jsObj, 'pronouns', object.pronouns);
  return jsObj;
}

Match _matchDeserializeWeb(IsarCollection<Match> collection, dynamic jsObj) {
  final object = Match(
    bio: IsarNative.jsObjectGet(jsObj, 'bio') ?? '',
    displayName: IsarNative.jsObjectGet(jsObj, 'displayName') ?? '',
    gender: IsarNative.jsObjectGet(jsObj, 'gender'),
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    interests: (IsarNative.jsObjectGet(jsObj, 'interests') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>() ??
        [],
    pronouns: IsarNative.jsObjectGet(jsObj, 'pronouns'),
  );
  return object;
}

P _matchDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'bio':
      return (IsarNative.jsObjectGet(jsObj, 'bio') ?? '') as P;
    case 'displayName':
      return (IsarNative.jsObjectGet(jsObj, 'displayName') ?? '') as P;
    case 'gender':
      return (IsarNative.jsObjectGet(jsObj, 'gender')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'interests':
      return ((IsarNative.jsObjectGet(jsObj, 'interests') as List?)
              ?.map((e) => e ?? '')
              .toList()
              .cast<String>() ??
          []) as P;
    case 'pronouns':
      return (IsarNative.jsObjectGet(jsObj, 'pronouns')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _matchAttachLinks(IsarCollection col, int id, Match object) {}

extension MatchQueryWhereSort on QueryBuilder<Match, Match, QWhere> {
  QueryBuilder<Match, Match, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension MatchQueryWhere on QueryBuilder<Match, Match, QWhereClause> {
  QueryBuilder<Match, Match, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension MatchQueryFilter on QueryBuilder<Match, Match, QFilterCondition> {
  QueryBuilder<Match, Match, QAfterFilterCondition> bioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'bio',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'bio',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> bioMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'bio',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'displayName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'displayName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> displayNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'displayName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'gender',
      value: null,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'gender',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'gender',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'gender',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'interests',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'interests',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> interestsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'interests',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'pronouns',
      value: null,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'pronouns',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'pronouns',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> pronounsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'pronouns',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension MatchQueryLinks on QueryBuilder<Match, Match, QFilterCondition> {}

extension MatchQueryWhereSortBy on QueryBuilder<Match, Match, QSortBy> {
  QueryBuilder<Match, Match, QAfterSortBy> sortByBio() {
    return addSortByInternal('bio', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByBioDesc() {
    return addSortByInternal('bio', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByDisplayName() {
    return addSortByInternal('displayName', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByDisplayNameDesc() {
    return addSortByInternal('displayName', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByGender() {
    return addSortByInternal('gender', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByGenderDesc() {
    return addSortByInternal('gender', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPronouns() {
    return addSortByInternal('pronouns', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByPronounsDesc() {
    return addSortByInternal('pronouns', Sort.desc);
  }
}

extension MatchQueryWhereSortThenBy on QueryBuilder<Match, Match, QSortThenBy> {
  QueryBuilder<Match, Match, QAfterSortBy> thenByBio() {
    return addSortByInternal('bio', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByBioDesc() {
    return addSortByInternal('bio', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByDisplayName() {
    return addSortByInternal('displayName', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByDisplayNameDesc() {
    return addSortByInternal('displayName', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByGender() {
    return addSortByInternal('gender', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByGenderDesc() {
    return addSortByInternal('gender', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPronouns() {
    return addSortByInternal('pronouns', Sort.asc);
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByPronounsDesc() {
    return addSortByInternal('pronouns', Sort.desc);
  }
}

extension MatchQueryWhereDistinct on QueryBuilder<Match, Match, QDistinct> {
  QueryBuilder<Match, Match, QDistinct> distinctByBio(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('bio', caseSensitive: caseSensitive);
  }

  QueryBuilder<Match, Match, QDistinct> distinctByDisplayName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('displayName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Match, Match, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('gender', caseSensitive: caseSensitive);
  }

  QueryBuilder<Match, Match, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Match, Match, QDistinct> distinctByPronouns(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('pronouns', caseSensitive: caseSensitive);
  }
}

extension MatchQueryProperty on QueryBuilder<Match, Match, QQueryProperty> {
  QueryBuilder<Match, String, QQueryOperations> bioProperty() {
    return addPropertyNameInternal('bio');
  }

  QueryBuilder<Match, String, QQueryOperations> displayNameProperty() {
    return addPropertyNameInternal('displayName');
  }

  QueryBuilder<Match, String?, QQueryOperations> genderProperty() {
    return addPropertyNameInternal('gender');
  }

  QueryBuilder<Match, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Match, List<String>, QQueryOperations> interestsProperty() {
    return addPropertyNameInternal('interests');
  }

  QueryBuilder<Match, String?, QQueryOperations> pronounsProperty() {
    return addPropertyNameInternal('pronouns');
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Match _$$_MatchFromJson(Map<String, dynamic> json) => _$_Match(
      id: json['id'] as int,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pronouns: json['pronouns'] as String?,
      gender: json['gender'] as String?,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_MatchToJson(_$_Match instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'media': instance.media,
      'pronouns': instance.pronouns,
      'gender': instance.gender,
      'interests': instance.interests,
    };

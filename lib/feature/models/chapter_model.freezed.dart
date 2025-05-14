// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChapterWrapper _$ChapterWrapperFromJson(Map<String, dynamic> json) {
  return _ChapterWrapper.fromJson(json);
}

/// @nodoc
mixin _$ChapterWrapper {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Chapter get attributes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterWrapperCopyWith<ChapterWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterWrapperCopyWith<$Res> {
  factory $ChapterWrapperCopyWith(
          ChapterWrapper value, $Res Function(ChapterWrapper) then) =
      _$ChapterWrapperCopyWithImpl<$Res, ChapterWrapper>;
  @useResult
  $Res call({String id, String type, Chapter attributes});

  $ChapterCopyWith<$Res> get attributes;
}

/// @nodoc
class _$ChapterWrapperCopyWithImpl<$Res, $Val extends ChapterWrapper>
    implements $ChapterWrapperCopyWith<$Res> {
  _$ChapterWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? attributes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Chapter,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChapterCopyWith<$Res> get attributes {
    return $ChapterCopyWith<$Res>(_value.attributes, (value) {
      return _then(_value.copyWith(attributes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChapterWrapperImplCopyWith<$Res>
    implements $ChapterWrapperCopyWith<$Res> {
  factory _$$ChapterWrapperImplCopyWith(_$ChapterWrapperImpl value,
          $Res Function(_$ChapterWrapperImpl) then) =
      __$$ChapterWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String type, Chapter attributes});

  @override
  $ChapterCopyWith<$Res> get attributes;
}

/// @nodoc
class __$$ChapterWrapperImplCopyWithImpl<$Res>
    extends _$ChapterWrapperCopyWithImpl<$Res, _$ChapterWrapperImpl>
    implements _$$ChapterWrapperImplCopyWith<$Res> {
  __$$ChapterWrapperImplCopyWithImpl(
      _$ChapterWrapperImpl _value, $Res Function(_$ChapterWrapperImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? attributes = null,
  }) {
    return _then(_$ChapterWrapperImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Chapter,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterWrapperImpl implements _ChapterWrapper {
  const _$ChapterWrapperImpl(
      {required this.id, required this.type, required this.attributes});

  factory _$ChapterWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterWrapperImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final Chapter attributes;

  @override
  String toString() {
    return 'ChapterWrapper(id: $id, type: $type, attributes: $attributes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterWrapperImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.attributes, attributes) ||
                other.attributes == attributes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, attributes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterWrapperImplCopyWith<_$ChapterWrapperImpl> get copyWith =>
      __$$ChapterWrapperImplCopyWithImpl<_$ChapterWrapperImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterWrapperImplToJson(
      this,
    );
  }
}

abstract class _ChapterWrapper implements ChapterWrapper {
  const factory _ChapterWrapper(
      {required final String id,
      required final String type,
      required final Chapter attributes}) = _$ChapterWrapperImpl;

  factory _ChapterWrapper.fromJson(Map<String, dynamic> json) =
      _$ChapterWrapperImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  Chapter get attributes;
  @override
  @JsonKey(ignore: true)
  _$$ChapterWrapperImplCopyWith<_$ChapterWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return _Chapter.fromJson(json);
}

/// @nodoc
mixin _$Chapter {
  String? get volume => throw _privateConstructorUsedError;
  String? get chapter => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String get translatedLanguage => throw _privateConstructorUsedError;
  String? get externalUrl => throw _privateConstructorUsedError;
  DateTime get publishAt => throw _privateConstructorUsedError;
  DateTime get readableAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get pages => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterCopyWith<Chapter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterCopyWith<$Res> {
  factory $ChapterCopyWith(Chapter value, $Res Function(Chapter) then) =
      _$ChapterCopyWithImpl<$Res, Chapter>;
  @useResult
  $Res call(
      {String? volume,
      String? chapter,
      String? title,
      String translatedLanguage,
      String? externalUrl,
      DateTime publishAt,
      DateTime readableAt,
      DateTime createdAt,
      DateTime updatedAt,
      int pages,
      int version});
}

/// @nodoc
class _$ChapterCopyWithImpl<$Res, $Val extends Chapter>
    implements $ChapterCopyWith<$Res> {
  _$ChapterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volume = freezed,
    Object? chapter = freezed,
    Object? title = freezed,
    Object? translatedLanguage = null,
    Object? externalUrl = freezed,
    Object? publishAt = null,
    Object? readableAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pages = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: null == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      publishAt: null == publishAt
          ? _value.publishAt
          : publishAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readableAt: null == readableAt
          ? _value.readableAt
          : readableAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterImplCopyWith<$Res> implements $ChapterCopyWith<$Res> {
  factory _$$ChapterImplCopyWith(
          _$ChapterImpl value, $Res Function(_$ChapterImpl) then) =
      __$$ChapterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? volume,
      String? chapter,
      String? title,
      String translatedLanguage,
      String? externalUrl,
      DateTime publishAt,
      DateTime readableAt,
      DateTime createdAt,
      DateTime updatedAt,
      int pages,
      int version});
}

/// @nodoc
class __$$ChapterImplCopyWithImpl<$Res>
    extends _$ChapterCopyWithImpl<$Res, _$ChapterImpl>
    implements _$$ChapterImplCopyWith<$Res> {
  __$$ChapterImplCopyWithImpl(
      _$ChapterImpl _value, $Res Function(_$ChapterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volume = freezed,
    Object? chapter = freezed,
    Object? title = freezed,
    Object? translatedLanguage = null,
    Object? externalUrl = freezed,
    Object? publishAt = null,
    Object? readableAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pages = null,
    Object? version = null,
  }) {
    return _then(_$ChapterImpl(
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      translatedLanguage: null == translatedLanguage
          ? _value.translatedLanguage
          : translatedLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      publishAt: null == publishAt
          ? _value.publishAt
          : publishAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readableAt: null == readableAt
          ? _value.readableAt
          : readableAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterImpl implements _Chapter {
  const _$ChapterImpl(
      {this.volume,
      this.chapter,
      this.title,
      required this.translatedLanguage,
      this.externalUrl,
      required this.publishAt,
      required this.readableAt,
      required this.createdAt,
      required this.updatedAt,
      required this.pages,
      required this.version});

  factory _$ChapterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterImplFromJson(json);

  @override
  final String? volume;
  @override
  final String? chapter;
  @override
  final String? title;
  @override
  final String translatedLanguage;
  @override
  final String? externalUrl;
  @override
  final DateTime publishAt;
  @override
  final DateTime readableAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int pages;
  @override
  final int version;

  @override
  String toString() {
    return 'Chapter(volume: $volume, chapter: $chapter, title: $title, translatedLanguage: $translatedLanguage, externalUrl: $externalUrl, publishAt: $publishAt, readableAt: $readableAt, createdAt: $createdAt, updatedAt: $updatedAt, pages: $pages, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterImpl &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.translatedLanguage, translatedLanguage) ||
                other.translatedLanguage == translatedLanguage) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.publishAt, publishAt) ||
                other.publishAt == publishAt) &&
            (identical(other.readableAt, readableAt) ||
                other.readableAt == readableAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pages, pages) || other.pages == pages) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      volume,
      chapter,
      title,
      translatedLanguage,
      externalUrl,
      publishAt,
      readableAt,
      createdAt,
      updatedAt,
      pages,
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterImplCopyWith<_$ChapterImpl> get copyWith =>
      __$$ChapterImplCopyWithImpl<_$ChapterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterImplToJson(
      this,
    );
  }
}

abstract class _Chapter implements Chapter {
  const factory _Chapter(
      {final String? volume,
      final String? chapter,
      final String? title,
      required final String translatedLanguage,
      final String? externalUrl,
      required final DateTime publishAt,
      required final DateTime readableAt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final int pages,
      required final int version}) = _$ChapterImpl;

  factory _Chapter.fromJson(Map<String, dynamic> json) = _$ChapterImpl.fromJson;

  @override
  String? get volume;
  @override
  String? get chapter;
  @override
  String? get title;
  @override
  String get translatedLanguage;
  @override
  String? get externalUrl;
  @override
  DateTime get publishAt;
  @override
  DateTime get readableAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get pages;
  @override
  int get version;
  @override
  @JsonKey(ignore: true)
  _$$ChapterImplCopyWith<_$ChapterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

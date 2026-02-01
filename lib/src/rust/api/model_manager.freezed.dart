// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModelStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModelStatus()';
}


}

/// @nodoc
class $ModelStatusCopyWith<$Res>  {
$ModelStatusCopyWith(ModelStatus _, $Res Function(ModelStatus) __);
}


/// Adds pattern-matching-related methods to [ModelStatus].
extension ModelStatusPatterns on ModelStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ModelStatus_Missing value)?  missing,TResult Function( ModelStatus_Present value)?  present,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ModelStatus_Missing() when missing != null:
return missing(_that);case ModelStatus_Present() when present != null:
return present(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ModelStatus_Missing value)  missing,required TResult Function( ModelStatus_Present value)  present,}){
final _that = this;
switch (_that) {
case ModelStatus_Missing():
return missing(_that);case ModelStatus_Present():
return present(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ModelStatus_Missing value)?  missing,TResult? Function( ModelStatus_Present value)?  present,}){
final _that = this;
switch (_that) {
case ModelStatus_Missing() when missing != null:
return missing(_that);case ModelStatus_Present() when present != null:
return present(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  missing,TResult Function( String field0)?  present,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ModelStatus_Missing() when missing != null:
return missing();case ModelStatus_Present() when present != null:
return present(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  missing,required TResult Function( String field0)  present,}) {final _that = this;
switch (_that) {
case ModelStatus_Missing():
return missing();case ModelStatus_Present():
return present(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  missing,TResult? Function( String field0)?  present,}) {final _that = this;
switch (_that) {
case ModelStatus_Missing() when missing != null:
return missing();case ModelStatus_Present() when present != null:
return present(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ModelStatus_Missing extends ModelStatus {
  const ModelStatus_Missing(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelStatus_Missing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModelStatus.missing()';
}


}




/// @nodoc


class ModelStatus_Present extends ModelStatus {
  const ModelStatus_Present(this.field0): super._();
  

 final  String field0;

/// Create a copy of ModelStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelStatus_PresentCopyWith<ModelStatus_Present> get copyWith => _$ModelStatus_PresentCopyWithImpl<ModelStatus_Present>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelStatus_Present&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ModelStatus.present(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ModelStatus_PresentCopyWith<$Res> implements $ModelStatusCopyWith<$Res> {
  factory $ModelStatus_PresentCopyWith(ModelStatus_Present value, $Res Function(ModelStatus_Present) _then) = _$ModelStatus_PresentCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$ModelStatus_PresentCopyWithImpl<$Res>
    implements $ModelStatus_PresentCopyWith<$Res> {
  _$ModelStatus_PresentCopyWithImpl(this._self, this._then);

  final ModelStatus_Present _self;
  final $Res Function(ModelStatus_Present) _then;

/// Create a copy of ModelStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ModelStatus_Present(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

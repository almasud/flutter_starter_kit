// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent()';
}


}

/// @nodoc
class $ProductEventCopyWith<$Res>  {
$ProductEventCopyWith(ProductEvent _, $Res Function(ProductEvent) __);
}


/// Adds pattern-matching-related methods to [ProductEvent].
extension ProductEventPatterns on ProductEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ProductsStarted value)?  productsStarted,TResult Function( _ProductsRefreshed value)?  productsRefreshed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductsStarted() when productsStarted != null:
return productsStarted(_that);case _ProductsRefreshed() when productsRefreshed != null:
return productsRefreshed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ProductsStarted value)  productsStarted,required TResult Function( _ProductsRefreshed value)  productsRefreshed,}){
final _that = this;
switch (_that) {
case _ProductsStarted():
return productsStarted(_that);case _ProductsRefreshed():
return productsRefreshed(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ProductsStarted value)?  productsStarted,TResult? Function( _ProductsRefreshed value)?  productsRefreshed,}){
final _that = this;
switch (_that) {
case _ProductsStarted() when productsStarted != null:
return productsStarted(_that);case _ProductsRefreshed() when productsRefreshed != null:
return productsRefreshed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  productsStarted,TResult Function()?  productsRefreshed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductsStarted() when productsStarted != null:
return productsStarted();case _ProductsRefreshed() when productsRefreshed != null:
return productsRefreshed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  productsStarted,required TResult Function()  productsRefreshed,}) {final _that = this;
switch (_that) {
case _ProductsStarted():
return productsStarted();case _ProductsRefreshed():
return productsRefreshed();case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  productsStarted,TResult? Function()?  productsRefreshed,}) {final _that = this;
switch (_that) {
case _ProductsStarted() when productsStarted != null:
return productsStarted();case _ProductsRefreshed() when productsRefreshed != null:
return productsRefreshed();case _:
  return null;

}
}

}

/// @nodoc


class _ProductsStarted implements ProductEvent {
  const _ProductsStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductsStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent.productsStarted()';
}


}




/// @nodoc


class _ProductsRefreshed implements ProductEvent {
  const _ProductsRefreshed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductsRefreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent.productsRefreshed()';
}


}




// dart format on

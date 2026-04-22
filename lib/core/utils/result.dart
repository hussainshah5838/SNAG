import '../errors/app_exception.dart';

/// Result<T> — same concept as Rust/Swift Result type.
///
/// Instead of try/catch everywhere in the UI, every service call
/// returns either:
///   Result.success(data)   ← happy path
///   Result.failure(error)  ← typed AppException
///
/// React Native equivalent: { data, error } pattern from react-query
/// or a custom useAsync hook return shape.
sealed class Result<T> {
  const Result();

  /// Wrap a successful value
  factory Result.success(T data) = Success<T>;

  /// Wrap a typed failure
  factory Result.failure(AppException error) = Failure<T>;

  /// True if this is a Success
  bool get isSuccess => this is Success<T>;

  /// True if this is a Failure
  bool get isFailure => this is Failure<T>;

  /// Get data — null if Failure
  T? get data => switch (this) {
        Success<T> s => s.value,
        Failure<T> _ => null,
      };

  /// Get error — null if Success
  AppException? get error => switch (this) {
        Success<T> _ => null,
        Failure<T> f => f.exception,
      };

  /// Transform the success value (like .map in RxJS)
  Result<R> map<R>(R Function(T) transform) => switch (this) {
        Success<T> s => Result.success(transform(s.value)),
        Failure<T> f => Result.failure(f.exception),
      };

  /// Run a callback on success, return this unchanged
  Result<T> onSuccess(void Function(T) callback) {
    if (this is Success<T>) callback((this as Success<T>).value);
    return this;
  }

  /// Run a callback on failure, return this unchanged
  Result<T> onFailure(void Function(AppException) callback) {
    if (this is Failure<T>) callback((this as Failure<T>).exception);
    return this;
  }
}

/// The success case — holds the actual data
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

/// The failure case — holds a typed AppException
final class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}

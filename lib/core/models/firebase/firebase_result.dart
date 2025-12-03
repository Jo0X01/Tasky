sealed class FBResult<T> {}

class FBResultSuccess<T> extends FBResult<T> {
  final T data;
  FBResultSuccess(this.data);
}

class FBResultError<T> extends FBResult<T> {
  final String errorMessage;
  FBResultError(this.errorMessage);
}

typedef ResultResponse<T> = Future<FBResult<T>>;
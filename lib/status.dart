class Status {
  final _value;
  const Status._internal(this._value);
  int get value => _value;

  static Status fromInt(int i) {
    return {
      Pending.value: Pending,
      Ok.value: Ok,
      ErrorAbort.value: ErrorAbort,
      ErrorBadConfig.value: ErrorBadConfig,
      ErrorBadConnection.value: ErrorBadConnection,
      ErrorBadData.value: ErrorBadData,
      ErrorBadDevice.value: ErrorBadDevice,
      ErrorBadGateway.value: ErrorBadGateway,
      ErrorBadParam.value: ErrorBadParam,
      ErrorBadReply.value: ErrorBadReply,
      ErrorBadStatus.value: ErrorBadStatus,
      ErrorClose.value: ErrorClose,
      ErrorCreate.value: ErrorCreate,
      ErrorDuplicate.value: ErrorDuplicate,
      ErrorEncode.value: ErrorEncode,
      ErrorMutexDestroy.value: ErrorMutexDestroy,
      ErrorMutexInit.value: ErrorMutexInit,
      ErrorMutexLock.value: ErrorMutexLock,
      ErrorMutexUnlock.value: ErrorMutexUnlock,
      ErrorNotAllowed.value: ErrorNotAllowed,
      ErrorNotFound.value: ErrorNotFound,
      ErrorNotImplemented.value: ErrorNotImplemented,
      ErrorNoData.value: ErrorNoData,
      ErrorNoMatch.value: ErrorNoMatch,
      ErrorNoMem.value: ErrorNoMem,
      ErrorNoResources.value: ErrorNoResources,
      ErrorNullPtr.value: ErrorNullPtr,
      ErrorOpen.value: ErrorOpen,
      ErrorOutOfBounds.value: ErrorOutOfBounds,
      ErrorRead.value: ErrorRead,
      ErrorRemoteErr.value: ErrorRemoteErr,
      ErrorThreadCreate.value: ErrorThreadCreate,
      ErrorThreadJoin.value: ErrorThreadJoin,
      ErrorTimeout.value: ErrorTimeout,
      ErrorTooLarge.value: ErrorTooLarge,
      ErrorTooSmall.value: ErrorTooSmall,
      ErrorUnsupported.value: ErrorUnsupported,
      ErrorWinsock.value: ErrorWinsock,
      ErrorWrite.value: ErrorWrite,
      ErrorPartial.value: ErrorPartial,
      ErrorBusy.value: ErrorBusy,
    }[i]!;
  }

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_STATUS_PENDING"/>
  static const Pending = Status._internal(1);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_STATUS_OK"/>
  static const Ok = const Status._internal(0);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_ABORT"/>
  static const ErrorAbort = const Status._internal(-1);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_CONFIG"/>
  static const ErrorBadConfig = const Status._internal(-2);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_CONNECTION"/>
  static const ErrorBadConnection = const Status._internal(-3);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_DATA"/>
  static const ErrorBadData = const Status._internal(-4);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_DEVICE"/>
  static const ErrorBadDevice = const Status._internal(-5);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_GATEWAY"/>
  static const ErrorBadGateway = const Status._internal(-6);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_PARAM"/>
  static const ErrorBadParam = const Status._internal(-7);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_REPLY"/>
  static const ErrorBadReply = const Status._internal(-8);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BAD_STATUS"/>
  static const ErrorBadStatus = const Status._internal(-9);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_CLOSE"/>
  static const ErrorClose = const Status._internal(-10);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_CREATE"/>
  static const ErrorCreate = const Status._internal(-11);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_DUPLICATE"/>
  static const ErrorDuplicate = const Status._internal(-12);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_ENCODE"/>
  static const ErrorEncode = const Status._internal(-13);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_MUTEX_DESTROY"/>
  static const ErrorMutexDestroy = const Status._internal(-14);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_MUTEX_INIT"/>
  static const ErrorMutexInit = const Status._internal(-15);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_MUTEX_LOCK"/>
  static const ErrorMutexLock = const Status._internal(-16);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_MUTEX_UNLOCK"/>
  static const ErrorMutexUnlock = const Status._internal(-17);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NOT_ALLOWED"/>
  static const ErrorNotAllowed = const Status._internal(-18);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NOT_FOUND"/>
  static const ErrorNotFound = const Status._internal(-19);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NOT_IMPLEMENTED"/>
  static const ErrorNotImplemented = const Status._internal(-20);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NO_DATA"/>
  static const ErrorNoData = const Status._internal(-21);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NO_MATCH"/>
  static const ErrorNoMatch = const Status._internal(-22);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NO_MEM"/>
  static const ErrorNoMem = const Status._internal(-23);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NO_RESOURCES"/>
  static const ErrorNoResources = const Status._internal(-24);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_NULL_PTR"/>
  static const ErrorNullPtr = const Status._internal(-25);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_OPEN"/>
  static const ErrorOpen = const Status._internal(-26);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_OUT_OF_BOUNDS"/>
  static const ErrorOutOfBounds = const Status._internal(-27);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_READ"/>
  static const ErrorRead = const Status._internal(-28);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_REMOTE_ERR"/>
  static const ErrorRemoteErr = const Status._internal(-29);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_THREAD_CREATE"/>
  static const ErrorThreadCreate = const Status._internal(-30);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_THREAD_JOIN"/>
  static const ErrorThreadJoin = const Status._internal(-31);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_TIMEOUT"/>
  static const ErrorTimeout = const Status._internal(-32);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_TOO_LARGE"/>
  static const ErrorTooLarge = const Status._internal(-33);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_TOO_SMALL"/>
  static const ErrorTooSmall = const Status._internal(-34);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_UNSUPPORTED"/>
  static const ErrorUnsupported = const Status._internal(-35);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_WINSOCK"/>
  static const ErrorWinsock = const Status._internal(-36);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_WRITE"/>
  static const ErrorWrite = const Status._internal(-37);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_PARTIAL"/>
  static const ErrorPartial = const Status._internal(-38);

  /// <inheritdoc cref="STATUS_CODES.PLCTAG_ERR_BUSY"/>
  static const ErrorBusy = const Status._internal(-39);
}

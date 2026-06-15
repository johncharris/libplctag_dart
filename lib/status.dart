/// Status and error codes returned by libplctag.
///
/// The integer value matches the `PLCTAG_*` codes from `libplctag.h`.
enum Status {
  pending(1, 'Pending'),
  ok(0, 'Ok'),
  errorAbort(-1, 'Abort'),
  errorBadConfig(-2, 'Bad Config'),
  errorBadConnection(-3, 'Bad Connection'),
  errorBadData(-4, 'Bad Data'),
  errorBadDevice(-5, 'Bad Device'),
  errorBadGateway(-6, 'Bad Gateway'),
  errorBadParam(-7, 'Bad Param'),
  errorBadReply(-8, 'Bad Reply'),
  errorBadStatus(-9, 'Bad Status'),
  errorClose(-10, 'Close'),
  errorCreate(-11, 'Create'),
  errorDuplicate(-12, 'Duplicate'),
  errorEncode(-13, 'Encode'),
  errorMutexDestroy(-14, 'Mutex Destroy'),
  errorMutexInit(-15, 'Mutex Init'),
  errorMutexLock(-16, 'Mutex Lock'),
  errorMutexUnlock(-17, 'Mutex Unlock'),
  errorNotAllowed(-18, 'Not Allowed'),
  errorNotFound(-19, 'Not Found'),
  errorNotImplemented(-20, 'Not Implemented'),
  errorNoData(-21, 'No Data'),
  errorNoMatch(-22, 'No Match'),
  errorNoMem(-23, 'No Mem'),
  errorNoResources(-24, 'No Resources'),
  errorNullPtr(-25, 'Null Pointer'),
  errorOpen(-26, 'Open'),
  errorOutOfBounds(-27, 'Out of Bounds'),
  errorRead(-28, 'Read'),
  errorRemoteErr(-29, 'Remote Error'),
  errorThreadCreate(-30, 'Thread Create'),
  errorThreadJoin(-31, 'Thread Join'),
  errorTimeout(-32, 'Timeout'),
  errorTooLarge(-33, 'Too Large'),
  errorTooSmall(-34, 'Too Small'),
  errorUnsupported(-35, 'Unsupported'),
  errorWinsock(-36, 'Winsock'),
  errorWrite(-37, 'Write'),
  errorPartial(-38, 'Partial'),
  errorBusy(-39, 'Busy');

  const Status(this.value, this.label);

  /// The integer code passed across the FFI boundary.
  final int value;

  /// Short human-readable label (the right-hand side of [toString]).
  final String label;

  /// Map a raw integer status code to its enum value.
  ///
  /// Throws [ArgumentError] if [code] is not a known status. The native
  /// library should never return an unknown code; if it does, treat it
  /// as a hard error rather than silently coercing.
  static Status fromInt(int code) => switch (code) {
        1 => pending,
        0 => ok,
        -1 => errorAbort,
        -2 => errorBadConfig,
        -3 => errorBadConnection,
        -4 => errorBadData,
        -5 => errorBadDevice,
        -6 => errorBadGateway,
        -7 => errorBadParam,
        -8 => errorBadReply,
        -9 => errorBadStatus,
        -10 => errorClose,
        -11 => errorCreate,
        -12 => errorDuplicate,
        -13 => errorEncode,
        -14 => errorMutexDestroy,
        -15 => errorMutexInit,
        -16 => errorMutexLock,
        -17 => errorMutexUnlock,
        -18 => errorNotAllowed,
        -19 => errorNotFound,
        -20 => errorNotImplemented,
        -21 => errorNoData,
        -22 => errorNoMatch,
        -23 => errorNoMem,
        -24 => errorNoResources,
        -25 => errorNullPtr,
        -26 => errorOpen,
        -27 => errorOutOfBounds,
        -28 => errorRead,
        -29 => errorRemoteErr,
        -30 => errorThreadCreate,
        -31 => errorThreadJoin,
        -32 => errorTimeout,
        -33 => errorTooLarge,
        -34 => errorTooSmall,
        -35 => errorUnsupported,
        -36 => errorWinsock,
        -37 => errorWrite,
        -38 => errorPartial,
        -39 => errorBusy,
        _ => throw ArgumentError.value(code, 'code', 'Unknown libplctag status'),
      };

  @override
  String toString() => '$value $label';
}

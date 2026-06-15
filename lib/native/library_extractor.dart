import 'dart:ffi' as ffi;
import 'dart:io' show Directory, File, Platform;
import 'package:path/path.dart' as path;

/// Locates the platform-specific libplctag binary and opens it.
///
/// Search order:
///   1. The directory containing the running executable (works for
///      `dart compile exe` output and Flutter desktop bundles).
///   2. The bundled `lib/libplctag/<platform>/<arch>/` path inside this
///      package (works for `dart test` / `dart run` invocations from source).
///   3. The system loader's default search path (lets users override with
///      `LD_LIBRARY_PATH`, the system package manager, or a symlink).
class LibraryExtractor {
  static ffi.DynamicLibrary getLibrary() {
    final candidates = _candidateLibraryPaths();
    Object? lastError;
    for (final candidate in candidates) {
      try {
        return ffi.DynamicLibrary.open(candidate);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception(
        'Could not locate libplctag. Tried: ${candidates.join(", ")}. Last error: $lastError');
  }

  static List<String> _candidateLibraryPaths() {
    final libraryFileName = Platform.isWindows ? 'plctag.dll' : 'libplctag.so';
    final result = <String>[];

    final execDir = path.dirname(Platform.resolvedExecutable);
    result.add(path.join(execDir, libraryFileName));

    final bundled = _bundledLibraryPath();
    if (bundled != null) result.add(bundled);

    result.add(libraryFileName);
    return result;
  }

  static String? _bundledLibraryPath() {
    final String archDir;
    final String libName;
    if (Platform.isWindows) {
      archDir = 'windows/x64';
      libName = 'plctag.dll';
    } else if (Platform.isLinux) {
      archDir = _looksLikeArm64() ? 'linux/aarch64' : 'linux/x64';
      libName = 'libplctag.so';
    } else {
      return null;
    }

    final seeds = <String>{
      path.dirname(Platform.script.toFilePath()),
      Directory.current.path,
      path.dirname(Platform.resolvedExecutable),
    };

    for (final seed in seeds) {
      final found = _walkUp(seed, archDir, libName);
      if (found != null) return found;
    }
    return null;
  }

  static String? _walkUp(String start, String archDir, String libName) {
    var dir = start;
    for (var depth = 0; depth < 8; depth++) {
      final candidate = path.join(dir, 'lib', 'libplctag', archDir, libName);
      if (File(candidate).existsSync()) return candidate;
      final parent = path.dirname(dir);
      if (parent == dir) break;
      dir = parent;
    }
    return null;
  }

  static bool _looksLikeArm64() {
    final hostType = Platform.environment['HOSTTYPE'] ?? '';
    if (hostType.contains('aarch64') || hostType.contains('arm64')) return true;
    final version = Platform.version.toLowerCase();
    return version.contains('arm64') || version.contains('aarch64');
  }
}

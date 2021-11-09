import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

class LibraryExtractor {
  static DynamicLibrary getLibrary() {
    String libraryPath;

    // if (Platform.isWindows)
    libraryPath = path.join(Directory.current.path, 'runtime/win_x64', 'plctag.dll');

    final dylib = ffi.DynamicLibrary.open(libraryPath);
    return dylib;
  }
}

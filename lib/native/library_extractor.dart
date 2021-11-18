import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

class LibraryExtractor {
  static DynamicLibrary getLibrary() {
    ffi.DynamicLibrary? dylib;

    print(Platform.resolvedExecutable);
    print(path.join(Platform.resolvedExecutable, "libplctag.so"));

    if (Platform.isWindows) {
      dylib = ffi.DynamicLibrary.open("plctag.dll");
    } else {
      var exePath = Platform.resolvedExecutable
          .substring(0, Platform.resolvedExecutable.lastIndexOf("/"));
      dylib = ffi.DynamicLibrary.open(path.join(exePath, "libplctag.so"));
    }
    // if (Platform.isWindows) {
    //   dylib = ffi.DynamicLibrary.open("lib/libplctag/windows/x64/plctag.dll");
    // }

    // if (Platform.isLinux) {
    //   try {
    //     dylib = ffi.DynamicLibrary.open("libplctag/linux/aarch64/libplctag.so");
    //   } catch (ex) {
    //     print(ex);
    //     dylib = ffi.DynamicLibrary.open("libplctag/linux/x64/libplctag.so");
    //   }
    // }

    // if (dylib == null) throw new Exception("Build Configuration not supported");

    return dylib;
  }
}

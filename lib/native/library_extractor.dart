import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;

class LibraryExtractor {
  static DynamicLibrary getLibrary() {
    ffi.DynamicLibrary? dylib;

    print(Directory.current.path + "/libplctag.so");

    if (Platform.isWindows) {
      dylib = ffi.DynamicLibrary.open("plctag.dll");
    } else {
      dylib = ffi.DynamicLibrary.open(Directory.current.path + "/libplctag.so");
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

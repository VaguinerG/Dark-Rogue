import os

--define:noSignalHandler
--define:danger
--define:strip
--define:useMalloc
--panics:on
--boundChecks:off
--opt:size

const AndroidApiVersion {.intdefine.} = 33
const AndroidNdk {.strdefine.} = "/opt/android-ndk"
when buildOS == "windows":
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/windows-x86_64"
elif buildOS == "linux":
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/linux-x86_64"
elif buildOS == "macosx":
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/darwin-x86_64"
const AndroidSysroot = AndroidToolchain / "sysroot"

when defined(android):
  --define:GraphicsApiOpenGlEs2
  --os:android
  --cc:clang
  when hostCPU == "arm":
    const AndroidTriple = "armv7a-linux-androideabi"
    const AndroidAbiFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
  elif hostCPU == "arm64":
    const AndroidTriple = "aarch64-linux-android"
    const AndroidAbiFlags = "-march=armv8-a -mfix-cortex-a53-835769"
  elif hostCPU == "i386":
    const AndroidTriple = "i686-linux-android"
    const AndroidAbiFlags = "-march=i686"
  elif hostCPU == "amd64":
    const AndroidTriple = "x86_64-linux-android"
    const AndroidAbiFlags = "-march=x86-64"
  const AndroidTarget = AndroidTriple & $AndroidApiVersion

  switch("clang.path", AndroidToolchain / "bin")
  switch("clang.cpp.path", AndroidToolchain / "bin")
  switch("clang.options.always", "--target=" & AndroidTarget & " --sysroot=" & AndroidSysroot &
         " -I" & AndroidSysroot / "usr/include" &
         " -I" & AndroidSysroot / "usr/include" / AndroidTriple & " " & AndroidAbiFlags &
         " -D__ANDROID__ -D__ANDROID_API__=" & $AndroidApiVersion)
  switch("clang.options.linker", "--target=" & AndroidTarget & " -shared " & AndroidAbiFlags)

  --define:androidNDK

elif defined(emscripten):
  --define:GraphicsApiOpenGlEs2
  --os:linux
  --cpu:wasm32
  --cc:clang
  --clang.exe:emcc
  --clang.linkerexe:emcc
  --clang.cpp.exe:emcc
  --clang.cpp.linkerexe:emcc
  --threads:on
  --define:NaylibWebAsyncify
  --passL:"-o web/index.html"
  --passL:"--shell-file web/minshell.html"

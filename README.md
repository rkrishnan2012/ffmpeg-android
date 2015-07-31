# FFmpeg Build Script - Android
Built for Arm-v7a, and x86

### Installation
```sh
export ANDROID_NDK=~/Documents/androidSDK/ndk-bundle
./build-ffmpeg.sh
```

### Enabled Options
```
  --enable-cross-compile \
  --disable-static \
  --enable-shared \
  --disable-programs \
  --disable-debug \
  --disable-ffmpeg \
  --disable-symver \
  --disable-doc \
  --disable-protocols \
  --enable-protocol=rtmp \
  --enable-fft \
  --enable-rdft \
  --enable-pthreads \
  --enable-parsers \
  --enable-demuxers \
  --enable-decoders \
  --enable-bsfs \
  --enable-network \
  --enable-swscale  \
  --enable-swresample  \
  --enable-avresample \
  --enable-hwaccels \
  --enable-decoder=rawvideo \
  --enable-neon \
  --enable-encoder=aac \
  --enable-encoder=flv \
  --enable-asm \
  --enable-version3
```

### License
The Free Software Foundation may publish revised and/or new versions of the GNU Lesser General Public License from time to time. Such new versions will be similar in spirit to the present version, but may differ in detail to address new problems or concerns.

Each version is given a distinguishing version number. If the Library as you received it specifies that a certain numbered version of the GNU Lesser General Public License “or any later version” applies to it, you have the option of following the terms and conditions either of that published version or of any later version published by the Free Software Foundation. If the Library as you received it does not specify a version number of the GNU Lesser General Public License, you may choose any version of the GNU Lesser General Public License ever published by the Free Software Foundation.

If the Library as you received it specifies that a proxy can decide whether future versions of the GNU Lesser General Public License shall apply, that proxy's public statement of acceptance of any version is permanent authorization for you to choose that version for the Library.
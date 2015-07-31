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
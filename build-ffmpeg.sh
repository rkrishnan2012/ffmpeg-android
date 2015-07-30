#!/bin/bash
ANDROID_NDK=~/Documents/androidSDK/ndk-bundle

DEST=`pwd`/build/ffmpeg && rm -rf $DEST
SOURCE=`pwd`/ffmpeg

TOOLCHAIN_ARM=/tmp/FFMpegWrapper-arm
TOOLCHAIN_X86=/tmp/FFMpegWrapper-x86
SYSROOT_ARM=$TOOLCHAIN_ARM/sysroot/
SYSROOT_X86=$TOOLCHAIN_X86/sysroot/

EXTRA_ARM_CFLAGS="-mthumb -fstrict-aliasing -Werror=strict-aliasing -Wl,--fix-cortex-a8"

export PATH=$TOOLCHAIN_ARM/bin:$TOOLCHAIN_X86/bin:$PATH


CFLAGS="-fpic -fasm \
  -finline-limit=300 -ffast-math \
  -fmodulo-sched -fmodulo-sched-allow-regmoves \
  -Wno-psabi -Wa,--noexecstack \
  -DANDROID \
  -O3"


FFMPEG_FLAGS="--target-os=linux \
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
  --enable-version3"

if [ -d $TOOLCHAIN_ARM ]; then
    echo "arm toolchain is already built."
else
    echo "building arm toolchain."
    $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=arm --install-dir=$TOOLCHAIN_ARM
fi

if [ -d $TOOLCHAIN_X86 ]; then
    echo "x86 toolchain is already built."
else
    $ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-16 --arch=x86 --install-dir=$TOOLCHAIN_X86
fi


if [ -d ffmpeg ]; then
  echo "ffmpeg is already cloned and patched."
  cd ffmpeg
else
  git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
  cd ffmpeg
fi

for version in neon; do
  case $version in
    neon)
      TOOLCHAIN_PREFIX=arm-linux-androideabi
      TARGET_ARCH=arm
      EXTRA_CFLAGS="$EXTRA_ARM_CFLAGS -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mvectorize-with-neon-quad"
      EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
      LIB_SUB="armeabi-v7a"
      ;;
    armv7)
      TOOLCHAIN_PREFIX=arm-linux-androideabi
      TARGET_ARCH=arm
      EXTRA_CFLAGS="$EXTRA_ARM_CFLAGS -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp"
      EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
      LIB_SUB="armeabi-v7a"
      ;;
    vfp)
      TOOLCHAIN_PREFIX=arm-linux-androideabi
      TARGET_ARCH=arm
      EXTRA_CFLAGS="$EXTRA_ARM_CFLAGS -march=armv6 -mfpu=vfp -mfloat-abi=softfp"
      EXTRA_LDFLAGS=""
      ;;
    armv6)
      TOOLCHAIN_PREFIX=arm-linux-androideabi
      TARGET_ARCH=arm
      EXTRA_CFLAGS="$EXTRA_ARM_CFLAGS -march=armv6"
      EXTRA_LDFLAGS=""
      ;;
     x86)
      TOOLCHAIN_PREFIX=i686-linux-android
      TARGET_ARCH=x86
      EXTRA_CFLAGS="-mtune=atom -mssse3 -mfpmath=sse"
      EXTRA_LDFLAGS=""
      EXTRA_FFMPEG_FLAGS="--disable-avx"
      LIB_SUB="x86"
      ;;
    *)
      EXTRA_CFLAGS=""
      EXTRA_LDFLAGS=""
      ;;
  esac

  export CC="ccache $TOOLCHAIN_PREFIX-gcc"
  export LD=$TOOLCHAIN_PREFIX-ld
  export AR=$TOOLCHAIN_PREFIX-ar


  PREFIX="$DEST/$version" && mkdir -p $PREFIX

  cd $SOURCE
  echo "Configure ffmpeg for $version."
  echo
  ./configure --prefix=$PREFIX --arch=$TARGET_ARCH --cross-prefix=$TOOLCHAIN_PREFIX- $FFMPEG_FLAGS $EXTRA_FFMPEG_FLAGS --extra-cflags="$CFLAGS $EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS -llog" | tee $PREFIX/configuration.txt
  cp config.* $PREFIX
  [ $PIPESTATUS == 0 ] || exit 1

  make clean
  make -j4 || exit 1
  make install || exit 1

  #mv ../libs/armeabi ../libs/$LIB_SUB
  #$CC -lm -lz -shared --sysroot=$SYSROOT -Wl,--no-undefined -Wl,-z,noexecstack $EXTRA_LDFLAGS libavutil/*.o libavutil/arm/*.o libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libswresample/*.o libswscale/*.o -o $PREFIX/libffmpeg.so

  #cp $PREFIX/libffmpeg.so $PREFIX/libffmpeg-debug.so
  #arm-linux-androideabi-strip --strip-unneeded $PREFIX/libffmpeg.so
done 

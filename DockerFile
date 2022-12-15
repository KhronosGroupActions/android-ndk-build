# Copyright (c) 2022, Khronos Group and Contributors
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 the "License";
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:3.17

RUN apk add --update wget git openjdk16 clang libxcb-dev libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev unzip

# Configure Android env variables
ENV ANDROID_SDK=/usr/local/android-sdk \
  ANDROID_NDK=/usr/local/android-ndk

ENV ANDROID_SDK_ROOT=$ANDROID_SDK \
  ANDROID_HOME=$ANDROID_SDK \
  ANDROID_SDK_TOOLS=$ANDROID_SDK/cmdline-tools \
  ANDROID_NDK_ROOT=$ANDROID_NDK \
  ANDROID_NDK_ARM=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

RUN mkdir -p $ANDROID_HOME

ENV PATH="$PATH:$ANDROID_HOME/platform-tools:${ANDROID_SDK_TOOLS}/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/bin:$GRADLE_HOME/bin"

# Configure Android NDK
ENV NDK_VERSION=r25b

RUN set -x && wget -q https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux.zip -O /tmp/android-ndk.zip \
  && unzip -qq /tmp/android-ndk.zip -d /usr/local \
  && mv /usr/local/android-ndk-* $ANDROID_NDK

ADD assets/package-list.txt $ANDROID_HOME/package-list.txt

# Confugre SDK Tools
ENV SDK_TOOLS_VERSION=6514223

RUN set -x && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O /tmp/sdk-tools-linux.zip \
  && echo ${ANDROID_SDK_TOOLS} \
  && mkdir -p ${ANDROID_SDK_TOOLS} \
  && unzip -qq /tmp/sdk-tools-linux.zip -d ${ANDROID_SDK_TOOLS} \
  && echo y | $ANDROID_SDK_TOOLS/tools/bin/sdkmanager --package_file=$ANDROID_HOME/package-list.txt --verbose
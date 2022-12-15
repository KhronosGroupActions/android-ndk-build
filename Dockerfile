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

RUN apk add --update bash wget git openjdk16 clang libxcb-dev libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev unzip gcompat

ENV ANDROID_SDK=/usr/local/android-sdk

ENV ANDROID_HOME=$ANDROID_SDK \
    ANDROID_SDK_TOOLS=$ANDROID_SDK/cmdline-tools

RUN mkdir -p $ANDROID_HOME

ADD assets/package-list.txt $ANDROID_HOME/package-list.txt

# Confugre SDK Tools
ENV SDK_TOOLS_VERSION=6514223

RUN set -x && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O /tmp/sdk-tools-linux.zip \
  && echo ${ANDROID_SDK_TOOLS} \
  && mkdir -p ${ANDROID_SDK_TOOLS} \
  && unzip -qq /tmp/sdk-tools-linux.zip -d ${ANDROID_SDK_TOOLS} \
  && echo y | $ANDROID_SDK_TOOLS/tools/bin/sdkmanager --package_file=$ANDROID_HOME/package-list.txt --verbose

# Add SDK installed cmake to the path
ENV PATH="$PATH:/usr/local/android-sdk/cmake/3.22.1/bin"

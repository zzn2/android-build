FROM ubuntu:16.04

MAINTAINER zhuzhidong@gmail.com

# Install sudo
RUN apt-get update \
  && apt-get -y install sudo \
  && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Install Java8
RUN apt-get install -y software-properties-common curl \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install utils
RUN apt-get -y install unzip git

# Install 32bit lib
RUN sudo apt-get -y install lib32stdc++6 lib32z1

# Download Android SDK
RUN curl -L https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o /tmp.zip
RUN unzip /tmp.zip -d /opt/android && rm /tmp.zip

ENV ANDROID_NDK_HOME /opt/android-ndk
# Download Android ndk
RUN curl -L https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip -o /ndk-tmp.zip
RUN unzip /ndk-tmp.zip -d ANDROID_NDK_HOME && rm /ndk-tmp.zip

# Environment variables
ENV ANDROID_HOME /opt/android
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_NDK_HOME:$PATH

# Update of Android SDK
RUN echo y | sdkmanager "platforms;android-24"
RUN echo y | sdkmanager "platforms;android-25"
RUN echo y | sdkmanager "build-tools;25.0.0"
RUN echo y | sdkmanager "build-tools;25.0.2"
RUN echo y | sdkmanager "build-tools;25.0.3"
RUN echo y | sdkmanager "platforms;android-26"
RUN echo y | sdkmanager "build-tools;26.0.0"
RUN echo y | sdkmanager "build-tools;26.0.1"
RUN echo y | sdkmanager "build-tools;26.0.2"
RUN echo y | sdkmanager "platforms;android-28"
RUN echo y | sdkmanager "build-tools;28.0.3"

# Accept licenses
RUN yes | sdkmanager --licenses

# Add Aliyun OSS command tool
RUN apt-get install -y python
ENV OSS_PATH /usr/bin/oss
RUN sudo mkdir $OSS_PATH
RUN curl -o osscmd.zip https://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/internal/oss/0.0.4/assets/sdk/OSS_Python_API_20160419.zip
RUN unzip osscmd.zip -d $OSS_PATH && rm osscmd.zip
ENV PATH $OSS_PATH:$PATH

# Gradle opts
ENV GRADLE_USER_HOME /cache
ENV GRADLE_OPTS "-Dorg.gradle.jvmargs=-Xmx4096M"

# Additional Path
ENV PATH $ANDROID_HOME/build-tools/26.0.2:$PATH

# Ruby
RUN sudo apt-get -y install ruby
RUN sudo gem install ruby_apk
RUN sudo gem install docopt

# KtLint
RUN curl -sSLO https://github.com/shyiko/ktlint/releases/download/0.23.1/ktlint && chmod a+x ktlint && sudo mv ktlint /usr/local/bin/

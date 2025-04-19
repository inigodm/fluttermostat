FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias básicas y herramientas de cross-compilación
RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    pkg-config cmake ninja-build clang \
    libgl1-mesa-dev libgles2-mesa-dev \
    qemu-user-static \
    libstdc++-arm-linux-gnueabihf-dev \
    libgtk-3-dev \
    && apt-get clean

# Instala Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
    && /opt/flutter/bin/flutter doctor

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Precache linux-arm engine (necesario para `flutter-pi`)
RUN flutter config --enable-linux-arm64 \
    && flutter config --enable-linux-arm32 \
    && flutter precache --linux

WORKDIR /app

# Copia tu proyecto Flutter aquí
# COPY . /app

# Por defecto entra en bash (puedes hacer override al correr)
CMD ["/bin/bash"]
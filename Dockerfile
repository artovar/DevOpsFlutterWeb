# Install Operating system and dependencies
FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN groupadd veryhigh -g 1000000
RUN useradd -r -u 1000000 -g veryhigh veryhigh
RUN touch file-with-high-id
RUN chown veryhigh:veryhigh file-with-high-id

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Record the exposed port
EXPOSE 5000

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]
RUN ["chown", "root:root" ,"app/server/server.sh"]

ENTRYPOINT ["/app/server/server.sh"]
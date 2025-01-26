FROM ubuntu:latest AS snapserver

# install dependencies
RUN apt-get update && \
    apt-get install -y build-essential cmake libboost-all-dev git && \
    apt-get install -y libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev && \
    apt-get upgrade -y

# install snapcast
RUN git clone --branch master https://github.com/badaix/snapcast.git && \
    cd snapcast && \
    mkdir build && \
    cd build && \
    cmake .. -DBOOST_ROOT=/usr/include/boost && \
    cmake .. -DBUILD_CLIENT=OFF -DBUILD_SERVER=ON -DBUILD_WITH_PULSE=OFF && \
    cmake --build .



FROM ubuntu:latest AS snapweb

# download and extract snapweb
RUN apt update && \
    apt install -y wget unzip && \
    wget https://github.com/badaix/snapweb/releases/download/v0.8.0/snapweb.zip && \
    unzip snapweb.zip -d snapweb



FROM ubuntu:latest AS librespot

# install dependencies, install rust and compile librespot
RUN apt-get update && \
    apt-get install -y build-essential curl libasound2-dev pkg-config && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    cargo install --git https://github.com/librespot-org/librespot.git --branch dev



FROM ubuntu:latest

# install dependencies
RUN apt-get update && \
    apt-get install -y libasound2-dev pkg-config libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev && \
    apt-get upgrade -y

# copy binaries from the build stages
COPY --from=snapserver /snapcast/bin/snapserver /usr/local/bin/
COPY --from=snapweb snapweb /usr/share/snapserver/snapweb
COPY --from=librespot /root/.cargo/bin/librespot /root/.cargo/bin/librespot

# copy and replace snapserver config file if necessary
COPY snapserver.conf /etc/snapserver.conf

# publish ports
EXPOSE 1704 1705 1780 5353 43945

# start snapserver
ENTRYPOINT [ "snapserver" ]

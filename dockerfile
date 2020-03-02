FROM mongo:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV MONGO_URL=mongodb://localhost:27017/tdarr
ENV PORT=8265
ENV ROOT_URL=http://0.0.0.0/
ENV NODE_ARGS="--max-old-space-size=16384"
ENV HOME=/home/Tdarr
ENV UID=1000
ENV GID=1000

RUN apt-get update && \
    apt-get install software-properties-common --no-install-recommends -yq && \
    add-apt-repository ppa:jonathonf/ffmpeg-4 && \
    add-apt-repository ppa:stebbins/handbrake-releases && \
    apt-get clean && \
    apt-get update && \
    apt-get install build-essential \
                    curl \
                    dbus \
                    dbus-x11 \
                    ffmpeg \
                    gcc \
                    gcc-multilib \
                    git-core \
                    gstreamer1.0-plugins-bad \
                    gstreamer1.0-plugins-ugly \
                    gvfs-bin \
                    handbrake-cli \
                    libavcodec-extra \
                    libavcodec-extra57 \
                    libcanberra-gtk-module \
                    libcurl4-gnutls-dev \
                    libdvdnav4 \
                    libdvdread4 \
                    libglib2.0-bin \
                    libleptonica-dev \
                    libnotify4 \
                    libnss3 \
                    libtesseract-dev \
                    libxss1 \
                    packagekit-gtk3-module \
                    subversion \
                    sudo \
                    tesseract-ocr \
                    trash-cli \
                    ubuntu-restricted-extras \
                    xdg-utils --no-install-recommends -yq && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get install nodejs -yq

ADD Tdarr ${HOME}/Tdarr
COPY start /usr/local/bin

RUN groupadd -g ${GID} -r tdarr && useradd -u ${UID} -r -g tdarr tdarr && usermod -aG mongodb tdarr

RUN mkdir -p ${HOME}/media ${HOME}/logs /temp && \
    touch ${HOME}/logs/tdarr.log ${HOME}/logs/mongodb.log && \
    chmod a+rwx ${HOME}/Tdarr/bundle/programs/server/assets/app/ccextractor/ccextractor && \
    chmod a+rwx ${HOME}/Tdarr/bundle/programs/server/assets/app/ffmpeg/ffmpeg42/ffmpeg* && \
    chown -R tdarr:tdarr ${HOME} && \
    chown -R tdarr:tdarr /temp && \
    chown tdarr:tdarr /usr/local/bin/*

EXPOSE 8265

USER tdarr

ENTRYPOINT ["/usr/local/bin/start"]

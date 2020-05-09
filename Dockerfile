FROM debian:stretch-slim

COPY . /srv
WORKDIR /srv

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        default-libmysqlclient-dev \
        libboost-iostreams-dev \
        libboost-system-dev \
        libev-dev \
        libjemalloc-dev \
        libmysql++-dev \
        pkg-config \
	mariadb-client \
	cron \
	procps \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && apt-get purge -y \
        build-essential \
        cmake \    
        pkg-config \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && mv /srv/build/ocelot /srv/ocelot \
    && mv /srv/ocelot.conf.dist /srv/ocelot.conf

EXPOSE 34000/tcp

ADD start_ocelot.sh /srv/start_ocelot.sh
CMD ["/bin/bash", "/srv/start_ocelot.sh"]
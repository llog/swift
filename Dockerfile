# ubuntu xenial-10160818
FROM ubuntu:latest
MAINTAINER huaixiaoz hello@itmp.top

# https://swift.org/builds/swift-3.0-release/ubuntu1510/swift-3.0-RELEASE/swift-3.0-RELEASE-ubuntu15.10.tar.gz
#ENV SWIFT_BRANCH development
#ENV SWIFT_VERSION DEVELOPMENT-SNAPSHOT-2016-09-02-a
#ENV SWIFT_PLATFORM ubuntu15.10
ENV SWIFT_BRANCH swift-3.1.1-release
ENV SWIFT_VERSION 3.1.1-RELEASE
ENV SWIFT_PLATFORM ubuntu16.04

# Install related packages
RUN apt-get update \
	&& apt-get install -y build-essential \
 	wget \
	clang \
	curl \
	libedit-dev \
	python2.7 \
	python2.7-dev \
	libicu-dev \
	libssl-dev \
	libxml2 \
	libcurl4-openssl-dev \
	pkg-config \
	rsync \
	git \
	htop \
	psmisc \
	vim \
	cloc \
	openssh-server \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - \
	&& gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

# Install Swift Ubuntu 14.04 Snapshot
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM \
	&& SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz \
	&& wget $SWIFT_URL \
	&& wget $SWIFT_URL.sig \
	&& gpg --batch --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig $SWIFT_ARCHIVE_NAME.tar.gz \
	&& tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 \
	&& rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

# Set Swift Path
ENV PATH /usr/bin:$PATH

# Print Installed Swift Version
RUN swift --version

# Go to Workspace
RUN mkdir -p /opt/swift
WORKDIR /opt/swift

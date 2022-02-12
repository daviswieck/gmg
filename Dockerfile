ARG BUILD_FROM
FROM $BUILD_FROM as builder
MAINTAINER davis.wieck@gmail.com

ENV LANG C.UTF-8

# Copied with minor edits from https://github.com/pbkhrv/rtl_433-hass-addons/blob/main/rtl_433/Dockerfile
RUN apk add --no-cache --virtual .buildDeps \
    build-base \
    libusb-dev \
    librtlsdr-dev \
    cmake \
    git

WORKDIR /build
RUN git clone https://github.com/avandeweghe/gmg
WORKDIR ./gmg

ARG gmgGitRevision=3.0.1
RUN git checkout ${gmgGitRevision}
WORKDIR ./build
RUN cmake ..
RUN make -j 4

WORKDIR /build/root
WORKDIR /build/gmg/build
RUN make DESTDIR=/build/root/ install
RUN ls -lah /build/root

FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache libusb \
    librtlsdr
WORKDIR /root
COPY --from=builder /build/root/ /

# Run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

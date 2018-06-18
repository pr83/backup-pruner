FROM alpine:3.2

ENV S3FS_VERSION 1.79
RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev \
    ruby ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    libstdc++ tzdata bash ca-certificates sshfs expect \
  && wget -qO- https://github.com/s3fs-fuse/s3fs-fuse/archive/v${S3FS_VERSION}.tar.gz|tar xz \
  && cd s3fs-fuse-${S3FS_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && rm -rf /var/cache/apk/*

ADD pruner/main /tmp/pruner
ADD Gemfile /tmp/pruner/
RUN bundler --gemfile=/tmp/pruner/Gemfile

ADD container/mount.sh /tmp
ADD container/mount_sftp_key_with_passphrase.exp /tmp

CMD ["/bin/bash", "/tmp/mount.sh"]
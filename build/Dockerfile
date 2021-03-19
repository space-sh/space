#
FROM alpine:3.6
MAINTAINER https://github.com/space-sh/space/

# Version
ARG VERSION
LABEL VERSION="$VERSION"
ENV VERSION $VERSION

# Space files
COPY Spacefile.sh Spacefile.yaml space ./

# Lua rocks and lua libs build dependencies
RUN     apk add --no-cache --virtual .build-deps autoconf gcc libc-dev lua5.1-dev make openssl unzip \

# Base install
    &&  apk add --no-cache bash curl git lua5.1 luajit yaml-dev \

# Lua rocks
    &&  curl -LO https://luarocks.org/releases/luarocks-2.4.1.tar.gz \
    &&  tar zxpf luarocks-2.4.1.tar.gz                  \
    &&  cd luarocks-2.4.1                               \
    &&  ./configure                                     \
    &&  make bootstrap                                  \
    &&  cd ..                                           \
    &&  rm -rf ./luarocks-2.4.1 luarocks-2.4.1.tar.gz   \

# Lua libs
    &&  luarocks install lbase64        \
    &&  luarocks install lua-cjson      \
    &&  luarocks install luaposix       \
    &&  luarocks install lyaml          \

# Cleanup
    &&  apk del .build-deps             \

# Space
    &&  ./space /install/               \
    &&  rm Spacefile.sh Spacefile.yaml space


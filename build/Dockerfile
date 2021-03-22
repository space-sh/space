#
FROM alpine:3.13
MAINTAINER https://github.com/space-sh/space/

# Version
ARG VERSION
LABEL VERSION="$VERSION"
ENV VERSION $VERSION

# Space files
COPY Spacefile.sh Spacefile.yaml space ./

# Base install
RUN apk add --no-cache bash curl git \

# Space
    &&  ./space /install/               \
    &&  rm Spacefile.sh Spacefile.yaml space

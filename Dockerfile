FROM php:7.4-apache

# version arg
ARG H5AI_VER

LABEL \
    org.opencontainers.image.h5ai.version="${H5AI_VER}" \
    maintainer="devster31"

# environment settings
ENV \
    H5AI_VER="${H5AI_VER}"

RUN \
    DEBIAN_FRONTEND=noninteracive \
    set -eux \
    && \
    apt-get update && apt-get install -y \
        unzip \
    && \
    echo "**** install h5ai and patch configuration ****" \
    && curl -sSL -o \
        /tmp/h5ai.zip \
            "http://release.larsjung.de/h5ai/h5ai-${H5AI_VER}.zip" \
    && unzip /tmp/h5ai.zip -d /var/www/html/ \
    && apt-get purge -y unzip && apt-get autoremove --purge -y \
    && \
    rm -frv \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

RUN \
    echo "**** configuring ****" \
    # add directory index for h5ai
    && sed -i -r -e '/DirectoryIndex disabled/d' /etc/apache2/conf-available/docker-php.conf \
    && sed -i -r -e 's#DirectoryIndex index.php index.html#DirectoryIndex index.php index.html /_h5ai/public/index.php#' /etc/apache2/conf-available/docker-php.conf \
    # change port to a non-privileged one
    && sed -i -r -e 's#Listen 80#Listen 9000#' /etc/apache2/ports.conf \
    && sed -i -r -e 's#:80#:9000#' /etc/apache2/sites-available/000-default.conf \
    # ensure entrypoint uses bash to use parameter expansion
    && sed -i -r -e 's#/bin/sh#/bin/bash#' /usr/local/bin/docker-php-entrypoint \
    # accepts APACHE_RUN_USER and APACHE_RUN_GROUP only expressed as #<UID> and #<GID> for now
    && sed -i -r -e '/set -e/a chown -R "${APACHE_RUN_USER:1}":"${APACHE_RUN_GROUP:1}" /var/www/html/_h5ai/' /usr/local/bin/docker-php-entrypoint

EXPOSE 9000

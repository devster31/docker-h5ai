# docker-h5ai

[![docker build](https://github.com/devster31/docker-h5ai/workflows/docker%20build/badge.svg)](https://github.com/devster31/docker-h5ai/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/devster31/h5ai.svg?style=flat-square&color=E68523&label=pulls&logo=docker&logoColor=FFFFFF)](https://hub.docker.com/r/devster31/h5ai)
[![Docker Stars](https://img.shields.io/docker/stars/devster31/h5ai.svg?style=flat-square&color=E68523&label=stars&logo=docker&logoColor=FFFFFF)](https://hub.docker.com/r/devster31/h5ai)

## Usage

Example snippet to run this container.

### docker-compose

```yaml
services:
  h5ai:
    container_name: h5ai
    environment:
        - "APACHE_RUN_USER=#${PUID}"
        - "APACHE_RUN_GROUP=#${PGID}"
    image: devster31/h5ai
    ports:
        - 9000:9000
    volumes:
      - "options.json:/var/www/html/_h5ai/private/conf/options.json"
      - "${MOUNT}/directory/:/var/www/html/directory/:ro"
```

## Parameters

This image is configured using the following parameters.

| Parameter | Function |
| :----: | --- |
| `-p 9000` | tcp connection port |
| `-e APACHE_RUN_USER=#1000` | for UserID - see below for explanation |
| `-e APACHE_RUN_GROUP=1000` | for GroupID - see below for explanation |
| `-v options.json:/var/www/html/_h5ai/private/conf/options.json` | To mount a custom `options.json` file. |
| `-v /directory/:/var/www/html/directory/` | To mount directories to be used with `h5ai`. |

It should not be necessary to mount directories as read only as show in the example above.

### APACHE_RUN_* variables

You can (and probably should) run this container using the UID/GID of a non-privileged user with read access to the files
on the underlying filesystem. The container will change the ownership of the `/var/www/html/_h5ai/` folder to this user
and start `apache` using this user.

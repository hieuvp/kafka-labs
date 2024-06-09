FROM bitnami/spark:3.5.0

ARG USERNAME
ARG UID
ARG GID

USER root

RUN groupadd -g $GID -o $USERNAME
RUN useradd -m -u $UID -g $GID -o -s /usr/bin/bash $USERNAME
RUN chown -R $UID:$GID /opt/bitnami/spark

USER $USERNAME

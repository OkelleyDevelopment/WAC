# Project Name: WAC - Workshop in A Container
# Author: Nicholas O'Kelley
# Date: Jun 13, 2021
# Last updated: 2021-08-09
# Purpose: Simple containerized Development environment

# Choosing the Ubuntu version that has not failed me yet.
FROM ubuntu:20.04

# Documentation for who is maintaining this image
LABEL maintainer="Nicholas O'Kelley okelleynp@gmail.com"

ARG LOCAL_USER=developer
# Can change later
ARG LOCAL_PASS=developer

# Default terminal
ENV TERM xterm
ENV CONTAINER_USER ${LOCAL_USER}
ENV TZ="America/New_York"

# This allows us to stop the tzdata interactive prompt from stalling the build
# Found here https://techoverflow.net/2019/05/18/how-to-fix-configuring-tzdata-interactive-input-when-building-docker-images/
ENV DEBIAN_FRONTEND=noninteractive


# On run, we want to have the needed developer tools in this environment
RUN apt-get install -y apt

RUN apt-get update \
    && apt-get install -yq apt-utils \
    && apt-get upgrade -yq \
    && apt-get install -yq \
    tzdata neovim curl sudo man wget git gawk zip xterm zsh \
    tmux locales \ 
    build-essential apt-transport-https jupyter-core jupyter-notebook \
    ca-certificates software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove 


# Setup Locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo "INSTALLING LANGS"

# Install Languages
RUN apt-get update \
   && apt-get install -yq python3 python3-pip \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   && apt-get autoremove 


# setup vim preferences for root
RUN echo "syntax on\nset number" > /root/.vimrc

# Setup the user
RUN groupadd -r ${LOCAL_USER} \
  && useradd --no-log-init -m -s /bin/zsh \
    -g ${LOCAL_USER} \
    -G audio,video \
    ${LOCAL_USER}

RUN mkdir -p /home/${LOCAL_USER} \
  && mkdir -p /home/${LOCAL_USER}/Downloads \
  && chown -R ${LOCAL_USER}:${LOCAL_USER} /home/${LOCAL_USER}

RUN echo ${LOCAL_USER}:${LOCAL_PASS} | chpasswd


# assign user to sudo
RUN adduser ${LOCAL_USER} sudo
RUN echo "${LOCAL_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# switch to local user
USER ${LOCAL_USER}
WORKDIR /home/${LOCAL_USER}

# setup vim preferences for user
RUN echo "syntax on\nset number" > /home/${LOCAL_USER}/.vimrc

CMD ["bash"]

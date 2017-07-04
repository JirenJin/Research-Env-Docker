FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
# uid and gid should be the same with host user (for volume permission)
ARG uid
ARG gid
ENV HOME /home/ubuntu

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo zsh \
    curl ca-certificates git vim

# create user using the same uid and gid of host user
RUN groupadd -g $gid ubuntu \
    && useradd -m -s /bin/zsh -u $uid -g $gid ubuntu \
    && usermod -aG sudo ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# change user from root to `ubuntu`
USER ubuntu
WORKDIR /home/ubuntu

# install coding environment
COPY env-install.sh $HOME
RUN sudo chown ubuntu:ubuntu $HOME/env-install.sh \
    && sh $HOME/env-install.sh

ENTRYPOINT ["/bin/zsh"]

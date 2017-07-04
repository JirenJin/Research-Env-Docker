FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
# uid and gid should be the same with host user (for volume permission)
ARG uid
ARG gid
ENV HOME /home/ubuntu

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo zsh \
    curl ca-certificates git vim \
    && rm -rf /var/lib/apt/lists/*

# create user using the same uid and gid of host user
RUN groupadd -g $gid ubuntu \
    && useradd -m -s /bin/zsh -u $uid -g $gid ubuntu \
    && usermod -aG sudo ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# change user from root to `ubuntu`
USER ubuntu
WORKDIR /home/ubuntu

# install coding environment
    # install ohmyzsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    # install pyenv
    && git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.zshrc \
    # install anaconda
    && zsh -c "source ~/.zshrc \
    && pyenv install anaconda3-4.4.0 \
    && pyenv rehash \
    && pyenv global anaconda3-4.4.0"
#COPY env-install.sh $HOME \
#RUN sudo chown ubuntu:ubuntu $HOME/env-install.sh \
#    && zsh $HOME/env-install.sh

ENTRYPOINT ["/bin/zsh"]

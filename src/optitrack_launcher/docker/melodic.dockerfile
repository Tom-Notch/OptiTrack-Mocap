 # =============================================================================
 # Created on Thu Jun 22 2023 15:02:05
 # Author: Mukai (Tom Notch) Yu
 # Email: mukaiy@andrew.cmu.edu
 # Affiliation: Carnegie Mellon University, Robotics Institute, the AirLab
 #
 # Copyright Ⓒ 2023 Mukai (Tom Notch) Yu
 # =============================================================================

FROM --platform=linux/amd64 ubuntu:18.04
ENV HOME_FOLDER=/root
WORKDIR ${HOME_FOLDER}/

# Fix apt install stuck problem
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update all obsolete packages to latest, install sudo, and cleanup
RUN apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt full-upgrade -y && \
    apt install -y sudo && \
    apt autoremove -y && \
    apt autoclean -y

# fix local time problem
RUN apt install -y tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# install python3 and pip3
RUN apt install -y python3-dev python3-pip python3-setuptools python3-wheel && \
    pip3 install --upgrade pip

# install python2 and pip2
RUN apt install -y python-dev python-pip python-setuptools python-wheel && \
    pip2 install --upgrade pip

# set default python version to 2
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2 2 && \
    update-alternatives --set python /usr/bin/python2

# set default pip version to pip2
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip2 2 && \
    update-alternatives --set pip /usr/bin/pip2

# install some goodies
RUN apt install -y lsb-release apt-utils software-properties-common zsh unzip ncdu git less screen tmux tree locate perl net-tools vim nano emacs htop curl wget build-essential cmake ffmpeg

# upgrade cmake to kitware official apt repo release version
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4 && \
    apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt install -y kitware-archive-keyring && \
    apt upgrade -y cmake && \
    apt autoremove -y

# install jtop
RUN sudo pip3 install -U jetson-stats

# copy all config files to home folder
COPY --from=home-folder-config ./. ${HOME_FOLDER}/

# install zsh, Oh-My-Zsh, and plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/latest/download/zsh-in-docker.sh)" -- \
    -t https://github.com/romkatv/powerlevel10k \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/CraigCarey/gstreamer-tab \
    -a "[[ ! -f ${HOME_FOLDER}/.p10k.zsh ]] || source ${HOME_FOLDER}/.p10k.zsh" \
    -a "bindkey -M emacs '^[[3;5~' kill-word" \
    -a "bindkey '^H' backward-kill-word" \
    -a "autoload -U compinit && compinit"

# change default shell for the $USER in the image building process for extra environment safety
RUN chsh -s $(which zsh)
SHELL [ "/bin/zsh", "-c" ]

#! install ROS melodic desktop full
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt install -y ros-melodic-desktop-full && \
    echo "source /opt/ros/melodic/setup.zsh" >> ${HOME_FOLDER}/.zshrc && \
    echo "source /opt/ros/melodic/setup.bash" >> ${HOME_FOLDER}/.bashrc && \
    apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool && \
    rosdep init && \
    rosdep update

# install catkin tools and rosmon
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    wget http://packages.ros.org/ros.key -O - | apt-key add - && \
    apt update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true && \
    apt install -y python3-catkin-tools ros-melodic-rosmon

# end of apt installs
RUN apt autoremove -y && \
    apt autoclean -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# entrypoint command
ENTRYPOINT [ "/bin/zsh", "-c", "source /root/.zshrc; zsh" ]

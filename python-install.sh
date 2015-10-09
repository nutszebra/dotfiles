#!/bin/bash -eu

set -x

sudo apt-get -qq -y update
# pyenv install
case ${OSTYPE} in
    linux*)
        git clone https://github.com/yyuu/pyenv ~/.pyenv
        sudo apt-get install -qq -y make build-essential libssl-dev zlib1g-dev libbz2-dev
        sudo apt-get install -qq -y libreadline-dev libsqlite3-dev wget curl llvm
        sudo apt-get install -qq -y libfreetype6-dev libblas-dev liblapack-dev gfortran

        # required for scipy
        sudo apt-get -qq -y install gfortran libopenblas-dev liblapack-dev g++

        # required for matplotlib
        sudo apt-get install -qq -y build-essential python3-tk tk-dev libpng12-dev

        # opencv
        sudo apt-get build-dep -y -qq python-opencv
    ;;
    darwin*)
        brew install pyenv
    ;;
esac

exec -l $SHELL
export PYENV_PATH=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

#
sudo pip install -U dpkt
sudo pip install -U mahotas
sudo pip install -U numpy
sudo pip install -U pandas
sudo pip install -U percol
sudo pip install -U pyflakes
sudo pip install -U pygeoip
sudo pip install -U pyopencv
sudo pip install -U requests
sudo pip install -U scikit-learn
sudo pip install -U scipy
sudo pip install -U see
sudo pip install -U virtualenv
sudo easy_install -U guppy
sudo easy_install -U nose

# if you have an error
# echo "/usr/lib/atlas-base" | sudo tee /etc/ld.so.conf.d/atlas-lib.conf
# sudo ldconfig

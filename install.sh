#!/bin/bash -e

black-echo() { echo "$(tput setaf 0)$*$(tput setaf 9)"; }
red-echo() { echo "$(tput setaf 1)$*$(tput setaf 9)"; }
green-echo() { echo "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow-echo() { echo "$(tput setaf 3)$*$(tput setaf 9)"; }
blue-echo() { echo "$(tput setaf 4)$*$(tput setaf 9)"; }
magenta-echo() { echo "$(tput setaf 5)$*$(tput setaf 9)"; }
cyan-echo() { echo "$(tput setaf 6)$*$(tput setaf 9)"; }
white-echo() { echo "$(tput setaf 7)$*$(tput setaf 9)"; }

function error {
    red-echo "Error occured"
    trap - ERR
    exit 1
}

trap error ERR

DOTPATH="~/.dotfiles"

:  "install dotfiles" && {
    case ${OSTYPE} in
        linux*)
            # install latest git
            sudo add-apt-repository -y ppa:git-core/ppa
            sudo apt-get update -qq
            sudo apt-get install -qq -y git
            ;;
    esac

    git clone https://github.com/iory/dotfiles.git $DOTPATH
}

[ ! -d ${HOME}/local ] && mkdir ${HOME}/local
[ ! -d ${HOME}/local/src ] && mkdir ${HOME}/local/src
[ ! -d ${HOME}/bin ] && mkdir ${HOME}/bin

:  "settings for Ubuntu" && {
    case ${OSTYPE} in
        linux*)
            : "install apt package" && {
                sudo apt-get update -qq
                sudo apt-get install -qq -y aptitude
                sudo apt-get install -qq -y ascii
                sudo apt-get install -qq -y boxes
                # pbzip2 parallel decompress
                sudo apt-get install -qq -y cmigemo migemo
                sudo apt-get install -qq -y colordiff
                sudo apt-get install -qq -y curl
                sudo apt-get install -qq -y dconf-cli
                sudo apt-get install -qq -y dconf-editor
                sudo apt-get install -qq -y dconf-tools
                sudo apt-get install -qq -y emacs-mozc
                sudo apt-get install -qq -y gimp
                sudo apt-get install -qq -y global
                sudo apt-get install -qq -y nodejs
                sudo apt-get install -qq -y npm
                sudo apt-get install -qq -y pbzip2
                sudo apt-get install -qq -y rlwrap
                sudo apt-get install -qq -y silversearcher-ag
                sudo apt-get install -qq -y source-highlight
                sudo apt-get install -qq -y ssh
                sudo apt-get install -qq -y tmux
                sudo apt-get install -qq -y unar
                sudo apt-get install -qq -y xsel
                sudo apt-get install -qq -y zsh
            }
            : "for CTF" && {
                sudo apt-get install -qq -y libmono-winforms2.0-cil
                sudo apt-get install -qq -y nasm
                sudo apt-get install -qq -y unrar
                sudo apt-get install -qq -y wireshark tshark

                : "install NetworkMiner" && {
                    wget www.netresec.com/?download=NetworkMiner -O /tmp/nm.zip
                    sudo unzip /tmp/nm.zip -d /opt/
                    cd /opt/NetworkMiner*
                    sudo chmod +x NetworkMiner.exe
                    sudo chmod -R go+w AssembledFiles/
                    sudo chmod -R go+w Captures/
                    sudo apt-get install -qq -y g++-multilib
                    sudo apt-get install -qq -y lib32stdc++6
                    sudo apt-get install -qq -y ghex
                    sudo apt-get install -qq -y scapy
                    git clone https://github.com/longld/peda.git ~/bin/peda
                    git clone https://github.com/slimm609/checksec.sh.git ~/bin/checksec.sh
                    sudo pip -q install --upgrade git+https://github.com/Gallopsled/pwntools.git
                }
            }

            : "install gem" && {
                sudo apt-add-repository -y ppa:brightbox/ruby-ng
                sudo apt-get update -qq -y
                sudo apt-get install -qq -y ruby2.2
                sudo apt-get install -qq -y ruby2.2-dev
                sudo gem install travis
                sudo gem install tmuxinator
            }

            : "set local install" && {
                sudo pip -q install wstool
                mkdir -p ~/local
                ln -sf $DOTPATH/rosinstall/local.install ~/local/.rosinstall
                (cd ~/local && wstool up)
            }

            # bash $DOTPATH/scripts/gsettings.sh

            # gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
            # dconf reset /org/gnome/settings-daemon/plugins/keyboard/active
            # dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
            # # gsettings set org.gnome.desktop.interface gtk-key-theme "Default"

            # # fcitx
            # sudo apt-get install -qq -y fcitx fcitx-mozc
            # gsettings set org.gnome.settings-daemon.plugins.keyboard active false

            # # change CapsLock as ctrl
            # dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"

            # fonts install
            (cd /tmp \
                    && git clone https://github.com/powerline/fonts.git \
                    && cd fonts \
                    && ./install.sh;)

            # custom short cut key
            python $DOTPATH/scripts/set_shortcut.py
            ;;
    esac
}

: "install for peco" && {
    (cd ${HOME}/local/src \
        && if [ ! -d peco_linux_amd64 ]; then
            wget https://github.com/peco/peco/releases/download/v0.1.12/peco_linux_amd64.tar.gz
            tar -C ${HOME}/local -xzf peco_linux_amd64.tar.gz
        fi;)
}

: "install emacs" && {
    sudo apt-add-repository -y ppa:ubuntu-elisp/ppa
    sudo apt-get -qq -y update
    sudo apt-get install -qq -y emacs-snapshot
    git clone https://github.com/syl20bnr/spacemacs.git ~/.emacs.d
}

: "vim install" && {
    VIM_HOME=$HOME/.vim

    [ ! -d $VIM_HOME ] && mkdir $VIM_HOME

    # if [ ! -e $VIM_HOME/nerdtree ]
    # git clone https://github.com/scrooloose/nerdtree.git ~/.vim

    if [ ! -e $VIM_HOME/vim-hybrid ]; then
        git clone http://github.com/w0ng/vim-hybrid.git $VIM_HOME/vim-hybrid
        ln -sf $VIM_HOME/vim-hybrid/colors $VIM_HOME/colors
    fi

    ln -sf `pwd`/.vimrc $HOME/.vimrc
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | bash
}

: "hub command install (github)" && {
    case ${OSTYPE} in
        darwin*)
            brew install hub
            ;;
        linux*)
            mkdir -p ~/bin
            if [ ! -d ~/bin/hub ]; then
                curl https://hub.github.com/standalone -sLo ~/bin/hub
            fi
            chmod +x ~/bin/hub
            ;;
    esac
}

: "set zsh" && {
    ZDOTDIR=$DOTPATH
    mkdir $ZDOTDIR/zsh/plugins -p
    cd $ZDOTDIR/zsh/plugins -p
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    sudo chsh -s `which zsh`
}

: "symbolic link for dotfiles" && {
    cd $DOTPATH
    for f in .??*; do
        [[ "$f" == ".git" ]] && continue
        [[ "$f" == ".DS_Store" ]] && continue
        [[ "$f" == ".travis.yaml" ]] && continue

        echo "$f"
        ln -sf `pwd`/"$f" ~/"$f"
    done
    bash $DOTPATH/config/install.sh
}

: "ipython settings" && {
    if [ ! -e $HOME/.ipython/profile_default/startup ]; then
        mkdir -p $HOME/.ipython/profile_default/startup
    fi
    ln -sf $DOTPATH/ipython-settings/00-first.py ~/.ipython/profile_default/startup/00-first.py
}

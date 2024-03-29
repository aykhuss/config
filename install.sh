#!/usr/bin/env bash
# [[file:README.org::*Installation][Installation:1]]
#> set up some directory variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "installing configuration from ${SCRIPT_DIR} ..."

#> make backups with user prompts
make_backup() {
    if [[ $# -ne 1 ]]; then
        echo "make_backup: need to pass one file, got $#"
        return 1
    fi
    local bak="$1.bak"
    if [[ -f "$1" ]]; then
        echo "backing up $1 to $bak"
        if [[ -f "$bak" ]]; then
            echo "file exists: '$bak'"
            read -r -p "overwrite? [y/N] " response
            case "$response" in
                [yY][eE][sS]|[yY])
                    mv "$1" "$bak"
                    ;;
                *)
                    return 0
                    ;;
            esac
        else
            mv "$1" "$bak"
        fi
    fi
}

# [[file:README.org::*Installation][]]
if ! [[ -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
# ends here
# [[file:README.org::*Installation][]]
if ! [[ -d "$HOME/bin" ]]; then
    git clone git@github.com:aykhuss/bin.git $HOME/bin
fi
# ends here
# [[file:README.org::*Installation][]]
if ! command -v starship &> /dev/null; then
    #> make sure $HOME/bin exists?
    wget https://starship.rs/install.sh
    sh install.sh -b $HOME/bin
    rm install.sh  # clean up
fi
# ends here
# [[file:README.org::*Installation][]]
make_backup "$HOME/.zshrc"
#> fill in the template variable for the path to this repo
sed -e "s|&AYKHUSS_CONFIG&|${SCRIPT_DIR}|g" ${SCRIPT_DIR}/zshrc > $HOME/.zshrc
#> this is the local configuration that is sourced in the main .zshrc
touch ${SCRIPT_DIR}/zshrc.local
# ends here
# [[file:README.org::*Installation][]]
! [[ -d "$HOME/.config" ]]  &&  mkdir $HOME/.config
make_backup "$HOME/.config/starship.toml"
cp ${SCRIPT_DIR}/starship.toml $HOME/.config/starship.toml
# ends here

# [[file:README.org::*Installation][]]
if ! [[ -d "$HOME/.tmux" ]]; then
    git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
    make_backup "$HOME/.tmux.conf"
    ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
    # cp $HOME/.tmux/.tmux.conf.local .
fi
make_backup $HOME/.tmux.conf.local
cp ${SCRIPT_DIR}/tmux.conf.local $HOME/.tmux.conf.local
# ends here
# [[file:README.org::*Installation][]]
if ! command -v pyenv &> /dev/null; then
    #> on macOS, we use homebrew to install
    if command -v brew &> /dev/null; then
        brew update
        brew install pyenv
    else
        curl https://pyenv.run | bash
    fi
fi
#> set up for zsh & reload
echo 'export PYTHONHOME=' >> ${SCRIPT_DIR}/zshrc.local
echo 'export PYTHONPATH=' >> ${SCRIPT_DIR}/zshrc.local
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${SCRIPT_DIR}/zshrc.local
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ${SCRIPT_DIR}/zshrc.local
echo 'eval "$(pyenv init -)"' >> ${SCRIPT_DIR}/zshrc.local
source ${SCRIPT_DIR}/zshrc.local
#> install a recent version and set it as the default
pyenv install 3.12.1
pyenv global 3.12.1
# ends here
# Installation:1 ends here

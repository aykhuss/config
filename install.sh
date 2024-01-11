#!/usr/bin/env bash
# [[file:README.org::*Installation][Installation:1]]
#> set up some directory variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "installing configuration from ${SCRIPT_DIR} ..."


# [[file:README.org::*Installation][]]
if ! command -v starship &> /dev/null; then
    #> make sure $HOME/bin exists?
    wget https://starship.rs/install.sh
    sh install.sh -b $HOME/bin
    rm install.sh  # clean up
fi
# ends here
# [[file:README.org::*Installation][]]
if [[ -f "$HOME/.zshrc" ]]; then
    echo "backing up $HOME/.zshrc to $HOME/.zshrc.bak"
    mv $HOME/.zshrc $HOME/.zshrc.bak
fi
#> fill in the template variable for the path to this repo
sed -e "s|&AYKHUSS_CONFIG&|${SCRIPT_DIR}|g" ${SCRIPT_DIR}/zshrc > $HOME/.zshrc
#> this is the local configuration that is sourced in the main .zshrc
touch ${SCRIPT_DIR}/zshrc.local
# ends here
# [[file:README.org::*Installation][]]
! [[ -d "$HOME/.config" ]]  &&  mkdir $HOME/.config
if [[ -f "$HOME/.config/starship.toml" ]]; then
    echo "backing up $HOME/.config/starship.toml to $HOME/.config/starship.toml.bak"
    mv $HOME/.config/starship.toml $HOME/.config/starship.toml.bak
fi
cp ${SCRIPT_DIR}/starship.toml $HOME/.config/starship.toml
# ends here

# [[file:README.org::*Installation][]]
if ! [[ -d "$HOME/.tmux" ]]; then
    git clone https://github.com/gpakosz/.tmux.git $HOME
    if [[ -f "$HOME/.tmux.conf" ]]; then
        echo "backing up $HOME/.tmux.conf to $HOME/.tmux.conf.bak"
        mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
    fi
    ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
    # cp $HOME/.tmux/.tmux.conf.local .
    cp ${SCRIPT_DIR}/tmux.conf.local $HOME/.tmux.conf.local
fi
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
fi
# ends here
# Installation:1 ends here

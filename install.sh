#!/usr/bin/env bash
# [[file:README.org::*Installation][Installation:1]]
#> set up some directory variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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
if [[ -f "$HOME/.zshrc" ]]; then
    echo "backing up $HOME/.zshrc to $HOME/.zshrc.bak"
    mv $HOME/.zshrc to $HOME/.zshrc.bak
fi
#> fill in the template variable for the path to this repo
sed -e "s/&AYKHUSS_CONFIG&/${SCRIPT_DIR}/g" ${SCRIPT_DIR}/zshrc > $HOME/.zshrc
#> this is the local configuration that is sourced in the main .zshrc
touch ${SCRIPT_DIR}/zshrc.local
# ends here
# [[file:README.org::*Installation][]]
! [[ -d "$HOME/.config" ]]  &&  mkdir $HOME/.config
if [[ -f "$HOME/.config/starship.toml" ]]; then
    echo "backing up $HOME/.config/starship.toml to $HOME/.config/starship.toml.bak"
    mv $HOME/.zshrc to $HOME/.zshrc.bak
fi
cp ${SCRIPT_DIR}/starship.toml > $HOME/.config/starship.toml
# ends here
# Installation:1 ends here
#!/usr/bin/env bash

set -x

DIR=~/.local/share/fonts

mkdir -p $DIR

pushd $DIR

curl -fLo "Fura Code Retina Nerd Font Complete.otf" https://github.com/haasosaurus/nerd-fonts/raw/regen-mono-font-fix/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete.otf

curl -fLo "Fura Code Retina Nerd Font Complete Mono.otf" https://github.com/haasosaurus/nerd-fonts/raw/regen-mono-font-fix/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.otf

curl -fLo "Fura Code Retina Nerd Font Complete Mono.ttf" https://github.com/haasosaurus/nerd-fonts/raw/regen-mono-font-fix/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf

curl -fLo "Fura Code Retina Nerd Font Complete.ttf" https://github.com/haasosaurus/nerd-fonts/raw/regen-mono-font-fix/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete.ttf

popd

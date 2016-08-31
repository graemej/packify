#!/bin/bash

# Taken from https://github.com/ayufan/travis-osx-vm-templates/tree/d398e1dd425e3936c02291fda844b987659c8b2c/scripts

set -eo pipefail

if ! which brew ; then
  echo "Installing brew and tapping buildkite/buildkite"

 # workaround for: https://github.com/Homebrew/install/issues/48
 mkdir -p ~/Library/Caches/Homebrew

  : | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap buildkite/buildkite
else
  echo "Updating brew"

  brew update
fi

# Upgrade outdated
brew upgrade `brew outdated` --quieter

# Install packages
brew_packages='rbenv'
brew install ${brew_packages}

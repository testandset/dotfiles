#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install ripgrep

brew install emacs
brew install emacs-plus

brew install the_silver_searcher
brew install jenv
brew install mas
brew install cask

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install pv
brew install rename
brew install tree
brew install ctags
brew install cscope

# spell check
brew install ispell --with-lang-en

# Remove outdated versions from the cellar.
brew cleanup

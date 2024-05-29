#!/bin/bash

FILES=(".zshrc" ".bashrc" ".p10k.zsh")  # List of dotfiles to manage
DOTFILES_DIR="$(pwd)"  # Assuming the script is run from the dotfiles directory


# Function to create symlinks
create_symlinks() {
  for file in "${FILES[@]}"; do
    if [ ! -L "$HOME/$file" ]; then
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
        echo "created symlink for $file."
    fi
  done
}

# Function to sync dotfiles
sync_dotfiles() {
  for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
      mv "$HOME/$file" "$DOTFILES_DIR/"
      echo "Copied $file to dotfiles directory."
      git add .
      git commit -m "Add $file"
    fi
  done
}

# Check for arguments
if [ "$1" == "sync" ]; then
  sync_dotfiles
  create_symlinks
elif [ "$1" == "install" ]; then
  create_symlinks
else
  echo "Usage: $0 {sync|install}"
fi
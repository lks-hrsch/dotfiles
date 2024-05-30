#!/bin/bash
set -x

FILES=(".zshrc" ".bashrc" ".p10k.zsh" ".config/alacritty" ".config/hypr" ".config/waybar")  # List of dotfiles to manage
DOTFILES_DIR="$(pwd)"  # Assuming the script is run from the dotfiles directory


# Function to create symlinks
create_symlinks() {
  for file in "${FILES[@]}"; do
    source="$HOME/$file"
    target="$DOTFILES_DIR/$file"
    if [ ! -L "$source" ]; then
        ln -sf "$target" "$source"
        echo "created symlink for $file."
    fi
  done
}

# Function to sync dotfiles to version control system
sync_dotfiles_to_vcs() {
  for file in "${FILES[@]}"; do
    source="$HOME/$file"
    target="$DOTFILES_DIR/$file"
    if [ -f "$source" ] && [ ! -L "$source" ]; then
      mv "v" "$target"
      echo "Copied $file to dotfiles directory."
      git add "$target"
      git commit -m "Add $file"
    fi
    if [ -d "$source" ] && [ ! -L "$source" ]; then
      mkdir -p $target
      mv "$source"/* "$target"
      rmdir "$source"
      echo "Copied $file to dotfiles directory."
      git add "$target/*"
      git commit -m "Add $file"
    fi
  done
}

# Check for arguments
if [ "$1" == "sync" ]; then
  sync_dotfiles_to_vcs
  create_symlinks
elif [ "$1" == "install" ]; then
  create_symlinks
else
  echo "Usage: $0 {sync|install}"
fi
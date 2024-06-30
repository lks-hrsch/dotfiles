#!/bin/bash
set -x

FILES=(".zshrc" ".p10k.zsh" ".config/alacritty" ".config/wallpaper") # List of dotfiles to manage
LINUX_FILES=(".bashrc" ".config/hypr" ".config/waybar")
MACOS_FILES=()
DOTFILES_DIR="$(pwd)"  # Assuming the script is run from the dotfiles directory

# Determine the OS
OS="$(uname)"

# Add Mac-specific files if on macOS
if [ "$OS" == "Darwin" ]; then
  FILES+=("${MACOS_FILES[@]}")
else
  FILES+=("${LINUX_FILES[@]}")
fi

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
#!/bin/bash

FILES=(".zshrc" ".bashrc")  # List of dotfiles to manage


# Function to create symlinks
create_symlinks() {
  for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
      mv "$HOME/$file" "./"
      echo "moved $file to git directory."
    fi
    ln -sf "./$file" "$HOME/$file"
    echo "created symlink for $file."
  done
}

# Function to sync dotfiles
sync_dotfiles() {
  for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
      cp "$HOME/$file" "./"
      echo "Copied $file to dotfiles directory."
      git add .
      git commit -m "Add $file"
    fi
  done
}

# Function to push changes to git
push_to_git() {
  cd "$DOTFILES_DIR" || exit
  git add .
  git commit -m "Update dotfiles"
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
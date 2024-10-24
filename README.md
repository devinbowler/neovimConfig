# Neovim Setup Guide

This guide explains how to install Neovim on Windows, set it up, and configure the `init.vim` file with features like file tree, themes, status line, and toggleable floating terminals.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1: Install Neovim](#step-1-install-neovim)
- [Step 2: Add Neovim to the System PATH](#step-2-add-neovim-to-the-system-path)
- [Step 3: Install a Plugin Manager (vim-plug)](#step-3-install-a-plugin-manager-vim-plug)
- [Step 4: Set Up the `init.vim` Configuration](#step-4-set-up-the-initvim-configuration)
- [Step 5: Install Plugins](#step-5-install-plugins)
- [Step 6: Test the Configuration](#step-6-test-the-configuration)
- [Conclusion](#conclusion)

---

## Prerequisites

- **Windows OS** (10 or later recommended)
- **PowerShell** (comes with Windows)

---

## Step 1: Install Neovim

1. Go to the official [Neovim releases page](https://github.com/neovim/neovim/releases).
2. Download the latest stable version for Windows (`.zip` file).
3. Extract the contents of the `.zip` file to a folder (e.g., `C:\Program Files\Neovim`).

---

## Step 2: Add Neovim to the System PATH

1. Open **PowerShell** as Administrator.
2. Type the following command to open the **Environment Variables** dialog:

   ```powershell
   rundll32 sysdm.cpl,EditEnvironmentVariables
   ```

3. Under **System Variables**, find the `Path` variable and click **Edit**.
4. Click **New** and add the path to the Neovim `bin` folder (e.g., `C:\Program Files\Neovim\bin`).
5. Click **OK** to save and exit.

---

## Step 3: Install a Plugin Manager (vim-plug)

We will use `vim-plug` to manage Neovim plugins.

1. Open **PowerShell** and run the following command to download and install `vim-plug`:

   ```powershell
   iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | `
       ni "$($env:LOCALAPPDATA)\nvim-data\site\autoload\plug.vim" -Force
   ```

---

## Step 4: Set Up the `init.vim` Configuration

1. Create the necessary directories for Neovim’s configuration files:

   ```powershell
   mkdir $env:LOCALAPPDATA\nvim
   ```

2. Create and open the `init.vim` file for editing:

   ```powershell
   nvim $env:LOCALAPPDATA\nvim\init.vim
   ```

3. In the `init.vim` file, configure your plugins, keybindings, and any other settings you want.

   Example configurations:
   - Install the **NERDTree** plugin for a file tree.
   - Install the **Gruvbox** theme for improved visuals.
   - Add **ToggleTerm** for toggleable floating terminals.
   - Define custom keybindings, such as `Ctrl + N` to toggle the file tree, and `Ctrl + T` to toggle a terminal.

4. **Save and close** the `init.vim` file by pressing `Esc` and typing `:wq`.

---

## Step 5: Install Plugins

1. Open Neovim by typing `nvim` in **PowerShell**.
2. Inside Neovim, run the following command to install the plugins:

   ```vim
   :PlugInstall
   ```

3. Neovim will download and install all the plugins defined in the `init.vim` file.

---

## Step 6: Test the Configuration

1. **Test the File Tree**: Press `Ctrl + N` to toggle the file tree (`NERDTree`).
2. **Test the Terminal**: 
   - Press `Ctrl + T` to open a floating terminal.
   - Press `Ctrl + Shift + T` to open a second floating terminal.
3. **Test Keybindings**:
   - Press `Ctrl + A` to select all text.
   - Press `Ctrl + A + A` to select the current block or paragraph.
   - Press `Ctrl + X` to delete the current line.

---

## Conclusion

You’ve successfully installed Neovim on Windows and set up a fully customized configuration with themes, a file tree, and toggleable floating terminals. Feel free to modify your `init.vim` file to suit your workflow, and check out more plugins for extended functionality!

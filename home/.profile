# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

export CHROMIUM_FLAGS="-ppapi-flash-path=/usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so --ppapi-flash-version=31.0.0.153"
export CHROME_BIN=chromium

export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=gasp -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

export PATH=$HOME/.linkerd2/bin:$HOME/.local/bin:$HOME/bin:$HOME/.yarn/bin:$PATH

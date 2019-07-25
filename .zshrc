# Path to your oh-my-zsh installation.
  export ZSH=/home/maruli/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
 HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(auto-notify httpie git history tmux archlinux vi-mode zsh-autosuggestions zsh-syntax-highlighting rust you-should-use minikube kubectl)
autoload -U compinit && compinit

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

fpath+=~/.zfunc

source $ZSH/oh-my-zsh.sh

# initialize conda
source /home/maruli/anaconda3/etc/profile.d/conda.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

 #Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi

 #Compilation flags
 export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sp=" curl -F 'sprunge=<-' http://sprunge.us"
alias ix=" curl -F 'f:1=<-' ix.io"

alias hwsensors='watch -tn1 "lscpu | grep MHz; printf '\n\n'; sensors"'

alias hr='printf $(printf "\e[$(shuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='

alias writeback='watch -n0.5 grep Writeback: /proc/meminfo'

unalias grv

[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile

#eval "$(thefuck --alias fuck)"

export PATH="$PATH:$HOME/.cargo/bin" # Add RUST and RUSTUP
export PATH="$PATH:/media/eins/commands"
export PATH="$PATH:/opt/android-sdk/ndk-bundle"
export PATH="$PATH:$HOME/.config/composer/vendor/bin" # Add composer
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dsun.java2d.opengl=true'
export _JAVA_AWT_WM_NONREPARENTING=1
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/cuda/lib64"
export CUDA_HOME=/opt/cuda/
export DOMAIN=erwin.manobo.de
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/riscv/bin"

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc # Add phpbrew

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# bindkey -e
# End of lines configured by zsh-newuser-install

# enable edit command like bash compatible
bindkey '\C-x\C-e' edit-command-line

#export GVM_ROOT=/home/maruli/.gvm
#. $GVM_ROOT/scripts/gvm-default

[[ -s "/home/maruli/.gvm/scripts/gvm" ]] && source "/home/maruli/.gvm/scripts/gvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

#autoload -U promptinit; promptinit
#prompt spaceship

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# set variable based on OS
OS=`cat /etc/os-release | grep -w NAME | sed -e 's/NAME=//g;s/"//g'`
if [ "$OS" = 'Arch Linux' ]; then
  export RUST_SOURCE_PATH='/media/eins/repos/rust/src'
  export RACER_BIN_PATH='/home/maruli/.cargo/bin/racer'
  export PHP_LS_PATH='/home/maruli/php_ls/vendor/felixfbecker/language-server/bin/php-language-server.php'
  [[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
elif [ $OS = 'Ubuntu' ]; then
  export RUST_SOURCE_PATH='/home/maruli/rust/src'
  export RACER_BIN_PATH='/home/maruli/.cargo/bin/racer'
  export PHP_LS_PATH='/home/maruli/php_ls/vendor/felixfbecker/language-server/bin/php-language-server.php'
  source ~/z/z.sh
else
  export RUST_SOURCE_PATH='not_found'
  export RACER_BIN_PATH='not_found'
  export PHP_LS_PATH='not_found'
fi

####### CUSTOM FUNCTIONS
# search the latest nightly rust that containts RLS
rust_update() {
  for i in `seq 0 99`; do
    echo " === === === "
    RUST_DATE=`date -u -d "-$i days" "+%Y-%m-%d"`
    echo "Checking $RUST_DATE..."
    TOML=`curl -sf https://static.rust-lang.org/dist/$RUST_DATE/channel-rust-nightly.toml`
    if [[ $? -gt 0 ]]; then
      echo "Rust $RUST_DATE does not exist"
    else
      if [[ -n `echo $TOML | grep rls` && -n `echo $TOML | grep fmt` ]]; then
        echo "Rust $RUST_DATE has both rls and rustfmt"
        echo "Run \"rustup default nightly-$RUST_DATE\" to install it"
        break
      fi
    fi
  done
}

# remove all changes on local repos
clean_git_repos() {
SCRIPT="
 cd {};
 if [ -n \"\$(git status --porcelain)\" ]; then
   echo \"at \$(pwd)\"
   #echo cleaning...
   git reset --hard HEAD
   git clean -f -d
 fi"

 find /media/eins/repos -name .git -type d -execdir sh -c $SCRIPT \;
}

# run image on qemu emulator
exec_vm() {
  qemu-system-x86_64 -full-screen -enable-kvm -boot d -cdrom $1 -m 1024 -vga qxl
  #qemu-system-x86_64 -enable-kvm -boot d -cdrom $1 -m 1024 -vga qxl
}

# generate psudo random string
random_string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

# share files using transfer.sh
transfer() {
  # write to output to tmpfile because of progress bar
  tmpfile=$( mktemp -t transferXXX )
  curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
  cat $tmpfile;
  rm -f $tmpfile;
}

# update all git repos
update_git_repo() {
  SCRIPT="
  OUTPUT=\$(git pull)
  STATUS=\$?

  if [ \$STATUS -eq 0 ]; then
    printf \"%s %s\n\" \$(pwd) $'\U0001f606'
  else
    printf \"%s %s\n\" \$(pwd) $'\U0001f605'
  fi
"
  #echo $SCRIPT
  find /media/eins/repos -name .git -type d -execdir sh -c $SCRIPT \;
}

# play media file in terminal
stream_hide() {
  # echo $1
  youtube-dl -q -o- $1  | mpv --no-vid -cache 8192 -
}

# set backlight
terang() {
  sudo tee /sys/class/backlight/intel_backlight/brightness <<< $1
}

if [[ ! -a ~/.zsh-async ]]; then
  git clone git@github.com:mafredri/zsh-async.git ~/.zsh-async
fi

. ~/.zsh-async/async.zsh

# load node on demand
load_nvm() {
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

 export PATH="$PATH:`yarn global bin`"
}

# Initialize worker
async_start_worker nvm_worker -n
async_register_callback nvm_worker load_nvm
async_job nvm_worker sleep 0.1

toggle_monitor() {
  intern=eDP-1-1
  extern=HDMI-1-1

  if xrandr | grep "$extern connected"; then
    xrandr --output "$intern" --primary --auto --output "$extern" --right-of "$intern" --auto
  else
    xrandr --output "$extern" --off --output "$intern" --auto
  fi
}

sync_santoni() {
  adb-sync --reverse /sdcard/{Alarms,CallRecordings,CamScanner,DCIM,Documents,Download,Learn6502Assembly,MagiskManager,Movies,Music,Notifications,ROM,Pictures,Podcasts,Ringtones,Signal,Subtitles,TWRP,Traveloka,WhatsApp,aat_data,bas,bluetooth,jpcc,substratum,torrent} /media/eins/santoni
}

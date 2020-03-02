{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/release-19.09.tar.gz;

    neovim.enable = true;
    browserpass.browsers = [ "chrome" "chromium" "firefox" ];
    browserpass.enable = true;
    command-not-found.enable = true;
    direnv.enable = true;
    feh.enable = true;
    htop.enable = true;
    jq.enable = true;
    lesspipe.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    man.enable = true;
    noti.enable = true;
    zathura.enable = true;

    #    password-store = {
    #      enable = true;
    #      package = pkgs.pass.withExtensions (ext: [ext.pass-audit ext.pass-genphrase ext.pass-update ext.pass-otp ext.pass-import]);
    #      settings = {
    #        PASSWORD_STORE_DIR = "$HOME/.password-store";
    #        PASSWORD_STORE_GPG_OPTS = "-a";
    #      };
    #    };


    keychain = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      keys = [ "id_ed25519" "id_rsa" ];
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.save = 9999999999;
      history.size = 9999999999;
      initExtra = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        COMPLETION_WAITING_DOTS="true"

        zstyle :omz:plugins:ssh-agent identities id_ed25519 id_rsa

        # Customize your oh-my-zsh options here
        ZSH_THEME="agnoster"
        plugins=( git history mosh pep8 python screen rsync sudo systemd ssh-agent docker docker-compose aws github command-not-found )

        source $ZSH/oh-my-zsh.sh


        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
          ${pkgs.fd}/bin/fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          ${pkgs.fd}/bin/fd --type d --hidden --follow --exclude ".git" . "$1"
        }

        export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --follow"

        . ${pkgs.fzf}/share/fzf/completion.zsh
        . ${pkgs.fzf}/share/fzf/key-bindings.zsh

        setopt extendedglob

        alias vim='nvim'
        alias edit-nixos='nvim /etc/nixos/**/*.nix~*/home/* -p'
        alias edit-home='nvim /etc/nixos/home/**/*.nix -p'
        alias edit-dotfiles='nvim $(${pkgs.fd}/bin/fd -I -H . -t f /etc/nixos/home/dotfiles | xargs) -p'
        alias home-edit='edit-home'
        alias nixos-edit='edit-nixos'
        alias dotfiles-edit='edit-dotfiles'
        alias he='edit-home'
        alias ne='edit-nixos'
        alias de='edit-dotfiles'
        alias vim-update='vim -c :PlugUpdate'
        alias rwifi='sudo sh -c "modprobe ath10k_pci -v -r; sleep 1; modprobe ath10k_pci -v"'
        alias t='${pkgs.todo-txt-cli}/bin/todo.sh -t'
        alias qrsel='${pkgs.xsel}/bin/xsel; ${pkgs.qrencode}/bin/qrencode -l H -t ANSIUTF8 `${pkgs.xsel}/bin/xsel`'
        alias clean-direnv="${pkgs.fd}/bin/fd -I -H -s -p -t d '\.direnv' /*~/nix~/media -x rm -rfv {};"
        alias clean-result="${pkgs.fd}/bin/fd -I -H -s -p -t l result /*~/nix~/media -x rm -fv {};"
        alias repair-store='sudo sh -c "mv /etc/nix/nix.conf /etc/nix/nix.conf.old; cp /etc/nix/nix.conf.old /etc/nix/nix.conf; sed -i /auto-op/d /etc/nix/nix.conf"; sudo nix-store --verify --repair --check-contents -vvv 2>&1 | tee ~/repair-`date +%Y%m%d-%H%M%S`.log'

        alias fehz='feh -Z'

        alias ns="nix search"
        alias nsu="nix search -u"
        alias nru="nix run -f channel:nixos-unstable"
        alias nr="nix run -f channel:nixos-20.03"

        alias ip="${pkgs.iproute}/bin/ip --color"
        alias 4="ip -4"
        alias 6="ip -6"

        alias x="${pkgs.atool}/bin/atool -x"
        alias git="${pkgs.gitAndTools.hub}/bin/hub"

        alias n='pushd /etc/nixos'
        alias cdn=n
        alias v='nvim'
        alias update='sudo sh -c "nix-channel --update"; nix-channel --update'
        alias upgrade='sudo sh -c "nixos-rebuild switch"; home-manager switch'
        alias build='nixos-rebuild build; home-manager build'
        alias rsync-copy='rsync -av --progress --partial -h'
        alias hm='home-manager switch'
        alias sl='ls'
        alias sudoi='sudo -i'
        alias reflink="cp --reflink=always"

        compdef t='todo.sh'
        compdef 4='ip'
        compdef 6='ip'
        compdef fehz='feh'
        compdef v='nvim'
        compdef edit-home='nvim'
        compdef edit-nixos='nvim'
        compdef edit-dotfiles='nvim'
        compdef home-edit='nvim'
        compdef nixos-edit='nvim'
        compdef dotfiles-edit='nvim'
        compdef ne='nvim'
        compdef he='nvim'
        compdef de='nvim'
        compdef rsync-copy='rsync'
        compdef sl='ls'
        compdef sudoi='sudo'
        compdef reflink='cp'

        function savepath {
          pwd > ~/.last_dir
        }

        function f {
          find $2 -iname "*$1*"
        }

        function nix-run {
          nix run nixpkgs.$1 -c "$*"
        }

        alias e=nix-run

        # restore last saved path
        if [ -f ~/.last_dir ]
            then cd `cat ~/.last_dir`
        fi

        # oh-my-zsh plugin doesn't take :(
        export HISTFILE="$HOME/.zhistory"
        export HISTSIZE=100000000
        export SAVEHIST=100000000

        setopt BANG_HIST                 # Treat the '!' character specially during expansion.
        setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
        setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
        setopt SHARE_HISTORY             # Share history between all sessions.
        setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
        setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
        setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
        setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
        setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
        setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
        setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
        setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
        #setopt HIST_BEEP                 # Beep when accessing nonexistent history.

        setopt complete_aliases

        export NIX_DEBUG_INFO_DIRS=~/.nix-profile/lib/debug:$NIX_DEBUG_INFO_DIRS
      '';
    };
  };
}

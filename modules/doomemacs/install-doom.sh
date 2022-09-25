until ping -c 1 'github.com' >/dev/null 2>&1; do sleep 5; done

if [[ ! -a $HOME/.emacs.d/.doomrc ]]; then
    rm -rf $HOME/.emacs.d
    
    git clone --depth 1 'https://github.com/doomemacs/doomemacs.git' $HOME/.emacs.d

    $HOME/.emacs.d/bin/doom install --force
else
    $HOME/.emacs.d/bin/doom sync
fi

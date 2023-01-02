{pkgs}:
  pkgs.vim_configurable.customize {
    name = "vim1";
    vimrcConfig.customRC= ''
      set number
      set encoding=utf8
      imap jj <Esc>
      set hidden
      nnoremap <C-N> :bnext<CR>
      nnoremap <C-P> :bprev<CR>
      tnoremap <Esc><Esc> <C-\><C-n>
      nnoremap <C-K> :ter ++curwin<CR>
      nnoremap <Del> :bd!<CR> 
    '';
    vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
      start=[
        fzf-vim
        vim-airline 
        YouCompleteMe
        vim-polyglot
        vim-fugitive
        haskell-vim
        coc-nvim
        direnv-vim
      ];
    };
  };

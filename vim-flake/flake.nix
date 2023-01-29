{
  description = "myvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";


    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  #let pkgs = nixpkgs.legacyPackages.x86_64-linux;
  let pkgs = import nixpkgs {
	system = "x86_64-linux";
	config.allowUnfree = true;
}; 

  nvim = pkgs.neovim.override {

    configure = {
      customRC= ''
        set number
        set encoding=utf8
        set mouse=a
        set clipboard+=unnamedplus
        imap jj <Esc>
        set hidden
        nnoremap <C-N> :bnext<CR>
        nnoremap <C-P> :bprev<CR>
        tnoremap <Esc> <C-\><C-n>
        nnoremap <C-K> :terminal<CR>
        nnoremap <Del> :bd!<CR> 
        nnoremap <silent> <C-J> :Files<CR>
        nnoremap <C-S> :Buffers<CR>
        nnoremap <C-H> :Rg<CR>
        nnoremap NF :NERDTreeFind<CR>
        cd /home/maxim/work/projects/datatailr
        lua << EOF
        require("lsp-format").setup{}
        require("lspconfig").purescriptls.setup{on_attach = require("lsp-format").on_attach}
        require("lspconfig").rust_analyzer.setup{on_attach = require("lsp-format").on_attach}
        require("lspconfig").pyright.setup{}
        require'cmp'.setup {
         sources = {
         	{ name = 'cmp_tabnine' },
         },
        }
        local tabnine = require('cmp_tabnine.config')
        
        tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {
        },
        show_prediction_strength = false
        })
        require("compe").setup {
          enabled = true;
          autocomplete = true;
          debug = false;
          min_length = 1;
          preselect = "enable";
          throttle_time = 80;
          source_timeout = 200;
          resolve_timeout = 800;
          incomplete_delay = 400;
          max_abbr_width = 100;
          max_kind_width = 100;
          max_menu_width = 100;
          documentation = {
            border = { "", "","", " ", "", "", "", " " }, 
            winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
            max_width = 120,
            min_width = 60,
            max_height = math.floor(vim.o.lines * 0.3),
            min_height = 1,
          };

          source = {
            path = true;
            buffer = true;
            calc = true;
            nvim_lsp = true;
            nvim_lua = true;
            vsnip = true;
            ultisnips = true;
            luasnip = true;
          };
        }
        EOF
        set completeopt-=preview
        let g:neoformat_enabled_purescript = ['purstidy']
        let g:neoformat_enabled_python = ['autopep8']
        let g:neoformat_basic_format_align = 1
        let g:neoformat_basic_format_retab = 1
        let g:neoformat_basic_format_trim = 1 
        command Act lua vim.lsp.buf.code_action()

      '';

    packages.myVimPackage = with pkgs.vimPlugins; {
      start=[
        fzf-vim
        vim-airline 
        direnv-vim
        vim-polyglot
        haskell-vim
        vim-fugitive
        nvim-lspconfig
        nerdtree
        nerdcommenter
        vim-surround
        nvim-compe
        lsp-format-nvim
        neoformat
        nvim-cmp
        cmp-tabnine
	lspkind-nvim
        
      ];
    };
    };
  }; 
  vim1 = pkgs.vim_configurable.customize {
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
      nnoremap <silent> <C-J> :Files<CR>
      nnoremap <C-S> :Buffers<CR>
      nnoremap <C-H> :Rg<CR>
      set mouse=a
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
  code = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      haskell.haskell
      bbenoist.nix
      tabnine.tabnine-vscode
      vscodevim.vim
      justusadam.language-haskell
      arrterian.nix-env-selector
    ];
  };
  emacs = pkgs.emacs;

  in
  {
    packages.x86_64-linux.myvim = vim1;
    packages.x86_64-linux.code = code;
    packages.x86_64-linux.nvim = nvim;
    packages.x86_64-linux.emacs = emacs;
  };
}

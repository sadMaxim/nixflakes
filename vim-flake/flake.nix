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
        nmap <C-_> gcc
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
        nnoremap HP :HopWord<CR>
        cd /home/maxim/work/projects/datatailr
        lua << EOF
        require("lsp-format").setup{}
        require("lspconfig").purescriptls.setup{on_attach = require("lsp-format").on_attach}
        require("lspconfig").rust_analyzer.setup{on_attach = require("lsp-format").on_attach}
        require("lspconfig").pyright.setup{}
        require'hop'.setup()
        require('nvim_comment').setup({comment_empty = false})
        local tabnine = require('cmp_tabnine.config')
        tabnine:setup({
        max_lines = 1000,
        max_num_results = 30,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {
        },
        show_prediction_strength = false
        })
        local cmp = require'cmp'

        cmp.setup {
         snippet = {
               -- REQUIRED - you must specify a snippet engine
               expand = function(args)
                 vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                 -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                 -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                 -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
               end,
             },
         mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),

         sources = cmp.config.sources({
         	{ name = 'cmp_tabnine' },
         	{ name = 'nvim_lsp' },
         	{ name = 'vsnip' },
         }),
        }
        
        --vim.cmd("colorscheme nightfox")
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
	hop-nvim
        nvim-lspconfig
	nvim-treesitter
        nerdtree
        vim-surround
        lsp-format-nvim
        neoformat
        nvim-cmp
        cmp-nvim-lsp
        nvim-snippy
        cmp-tabnine
	lspkind-nvim
	nvim-comment
	nightfox-nvim
      ];
    };
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
    packages.x86_64-linux.code = code;
    packages.x86_64-linux.nvim = nvim;
    packages.x86_64-linux.emacs = emacs;
  };
}

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
        highlight Pmenu ctermbg=gray guibg=dark

        nnoremap <C-N> :bnext<CR>
        nnoremap <C-P> :bprev<CR>
        tnoremap <Esc> <C-\><C-n>
        nnoremap <Del> :bd!<CR> 
        nnoremap NF :NvimTreeFindFile<CR>
        nnoremap HP :HopWord<CR>
        nnoremap <leader>ff <cmd>Telescope find_files<CR>
        nnoremap <leader>fg <cmd>Telescope live_grep<CR>
        nnoremap <leader>fb <cmd>Telescope buffers<CR>
        nnoremap <leader>fh <cmd>Telescope help_tags<CR>
        nnoremap <Leader>f :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))<cr>

        cd /home/maxim/work/projects/datatailr
        lua << EOF
        require('lualine').setup({options = {theme = 'gruvbox'}})
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
        
        --nvim-tree 
        
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        
        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
        
        -- empty setup using defaults
        require("nvim-tree").setup()
        
        -- OR setup with some options
        require("nvim-tree").setup({
          sort_by = "case_sensitive",
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        })

        require'nvim-treesitter.configs'.setup {
          -- A list of parser names, or "all" (the five listed parsers should always be installed)
          -- ensure_installed = { "c","python", "lua", "vim", "help", "query" },
        
          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,
        
          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = false,
        
          -- List of parsers to ignore installing (for "all")
          -- ignore_install = { "javascript" },
        
          ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
          -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
        
          highlight = {
            enable = true,
        
            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            -- disable = { "c", "rust" },
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
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
        direnv-vim
	hop-nvim
        nvim-lspconfig
	nvim-treesitter.withAllGrammars
	nvim-tree-lua
        lsp-format-nvim
        neoformat
        nvim-cmp
        cmp-nvim-lsp
        nvim-snippy
        cmp-tabnine
	lspkind-nvim
	nvim-comment
	telescope-nvim
        lualine-nvim
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

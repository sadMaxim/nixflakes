{
    plugins.lsp = {
      enable = true;
      servers = {

        pyright.enable = true;
        pyright.package = null;

        # nixd.enable = true;

        purescriptls.enable = true;
        purescriptls.package = null;
        purescriptls.filetypes = ["dhall" "purescript"];

        rust_analyzer.enable = true;
        rust_analyzer.installRustc = false;
        rust_analyzer.installCargo = false;

        gopls.enable = true;

        # haskell
        hls.enable = true;
        hls.installGhc = false;

        svelte.enable = true;
        # aiken.enable = true;
        ts_ls.enable = true;
      };
    };

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = ["purescriptls"];
    };
}

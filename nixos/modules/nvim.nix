{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    # Build essentials (Treesitter parsers + telescope-fzf-native)
    gcc
    gnumake
    tree-sitter
    
    # LSPs
    typescript-language-server      # Flattened out of nodePackages
    vscode-langservers-extracted    # HTML, CSS, JSON, ESLint LSP
    emmet-ls
    lua-language-server
    intelephense                    # Flattened out of nodePackages
    
    # Formatters
    stylua
    clang-tools                     # clang-format for C/C++
    prettierd                       # Daemonized formatter
    gdtoolkit_4                     # gdformat + gdlint (Godot 4)
    
    # Linters
    cpplint
    eslint_d                        # Fast daemonized eslint for nvim-lint
  ];
}

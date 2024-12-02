self: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.neovimConfig;
in
  with lib; {
    options.hm.neovimConfig = {
      enable = mkEnableOption "Enable this Neovim configuration.";
      config = lib.mkOption {
        type = lib.types.path;
        default = ../nvim;
      };
    };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        wl-clipboard # For system clipboard capabilities
        ripgrep # For BurntSushi/ripgrep
        gcc # For installing treesitter parsers
      ];

      # So the entire folder isn't linked to the nix store. This allows you add or replace individual files for testing without having to rebuild all the time.
      xdg.configFile."nvim" = {
        source = cfg.config;
        recursive = true;
      };
    };
  }

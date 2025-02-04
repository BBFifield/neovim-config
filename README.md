# neovim-config

This is my personalized neovim configuration, tailored to how I'd like an editor to mostly look and function.

## Installation

The configuration files themselves are located inside `./nvim` and set up is pretty trivial since all that needs to be done is a straight copy and paste to your neovim directory.

As for dependencies, make sure the following is installed in your environment:

- `wl-clipboard` # For system clipboard capabilities
- `ripgrep` # For BurntSushi/ripgrep
- `gcc` # For installing treesitter parsers

## NixOS

Included in the repository is a flake and home-manager module to expedite the setup if you happen to run a home-manager environment on NixOS or any other supported linux distribution. The module will install all required dependencies to ensure the configuration works as intended.

1. Add my repo as an input to your flake `inputs.neovim-config.url = "github:BBFifield/neovim-config";`
2. Add `imports = [inputs.neovim-config.homeManagerModules.default];` into your home-manager config
3. Set `hm.neovimConfig.enable = true;` to enable my configuration.

Optionally, you can provide your own configuration by setting `hm.neovimConfig.config` to a path containing your config directory.






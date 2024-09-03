{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    nixpkgs,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    packages = forAllSystems (system: rec {
      pkgs = nixpkgs.legacyPackages.${system};
      default = let 
        package = pkgs.neovim-unwrapped;
        config = pkgs.neovimUtils.makeNeovimConfig {
          customRC = pkgs.writeTextFile {
            name = "init.lua";
            text = builtins.readFile ./init.lua;
          };
        };
      in 
        pkgs.wrapNeovimUnstable package (config);
    });
  };
}
/*environment.systemPackages = with pkgs; [
    neovim
  ];

  environment.etc."nvim/init.lua".source = /path/to/your/init.lua;*/
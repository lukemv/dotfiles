{
  # Pins the user-level CLI tools these dotfiles are written against, so a
  # config and the binary that reads it move together. herdr is why: its
  # sidebar config gained `rules` on a box running 0.9, and a Mac still on
  # 0.8.2 rejected the whole file and fell back to defaults. flake.lock is the
  # record of which versions every machine runs; bump it with
  # `nix flake update`, test, and commit the lock with any config that needs it.
  #
  # Scope is deliberately narrow: Dotbot still links configs, Salt still owns
  # the Fedora system layer, and Windows still runs install.ps1. Tools move in
  # here one at a time.
  description = "User-level tool versions for these dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        { system, username, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./nix/home.nix
            { home = { inherit username homeDirectory; }; }
          ];
        };
    in
    {
      # Named "<user>@<os>": scripts/<os>/install-nix.sh looks up
      # "$USER@<os>". Apply with `make install-nix`.
      homeConfigurations = {
        "me@darwin" = mkHome {
          system = "aarch64-darwin";
          username = "me";
          homeDirectory = "/Users/me";
        };
        # Linux boxes get an entry here once they move over, e.g.
        # "<user>@linux" = mkHome {
        #   system = "x86_64-linux";
        #   username = "<user>";
        #   homeDirectory = "/home/<user>";
        # };
      };
    };
}

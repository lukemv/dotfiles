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
      # The user comes from the environment rather than being written here,
      # so no username or home path is published and one entry serves every
      # machine of an OS. That needs --impure, which scripts/<os>/install-nix.sh
      # passes; tool versions are still fixed by flake.lock.
      env =
        name:
        let
          v = builtins.getEnv name;
        in
        if v == "" then throw "${name} is unset; run with --impure (see docs/nix-*.md)" else v;

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./nix/home.nix
            {
              home = {
                username = env "USER";
                homeDirectory = env "HOME";
              };
            }
          ];
        };
    in
    {
      # Keyed by OS: scripts/<os>/install-nix.sh switches to ".#<os>".
      homeConfigurations = {
        darwin = mkHome "aarch64-darwin";
        linux = mkHome "x86_64-linux";
      };
    };
}

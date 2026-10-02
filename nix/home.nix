{ pkgs, ... }:
{
  # Packages only, not programs.<tool>. The programs.* modules write their own
  # config files and shell hooks, and Dotbot already links
  # ~/.config/atuin/config.toml while zshrc runs `atuin init zsh`; two owners
  # of one file would fight. herdr's config is composed by
  # scripts/install-herdr-config.sh for the same reason. Configs move in here
  # once a tool's Dotbot entry is retired.
  home.packages = with pkgs; [
    # Updated through flake.lock, not `herdr update`: the self-updater
    # cannot replace a binary in the read-only Nix store.
    herdr
    # update_check is off in atuin/config.toml; the lock decides the version.
    atuin
  ];

  programs.home-manager.enable = true;

  # The home-manager release this config was first written against. It gates
  # stateful defaults, not package versions, so it stays put across upgrades.
  home.stateVersion = "26.05";
}

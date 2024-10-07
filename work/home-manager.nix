{ stdenv, pkgs, ... }:
let
  awsumeOnepassword = pkgs.callPackage ../packages/awsume-1password.nix { };
  awsumeConsole = pkgs.callPackage ../packages/awsume-console.nix { };
  awsumePlugins = pkgs.callPackage ../packages/awsume-with-plugins.nix { plugins = [ awsumeOnepassword awsumeConsole ]; };
in
{
  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      act
      emacs
      kubectl
      kubectx
      kubernetes-helm
      oh-my-zsh
      python3
      awsumePlugins
      rbenv
    ];

    file.".awsume/config.yaml".source = ./config/awsume.yaml;

    file.".emacs.d/init.el".source = ../shared/emacs.el;

    stateVersion = "24.05";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        c = "awsume -c";
        k = "kubectl";
      };

      initExtra = ''
      . "$HOME/.cargo/env"
      alias awsume=". awsume"

      e() {
        awsume "''${1}"
        kubectx "''${1}"
        kubens apps
        export GOVUK_ENV="''${1}"
      }

      export EDITOR="${pkgs.vim}/bin/vim"
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;

        python.disabled = true;
        gcloud.disabled = true;
        username.disabled = true;
        line_break.disabled = true;
        package.disabled = true;
      };
    };
  };
}

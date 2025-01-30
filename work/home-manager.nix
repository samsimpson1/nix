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
      bash
      emacs
      kubectl
      kubectx
      kubernetes-helm
      oh-my-zsh
      python3
      awsumePlugins
      rbenv
      pre-commit
      tenv
    ];

    file.".awsume/config.yaml".source = ./config/awsume.yaml;

    file.".wezterm.lua".source = ./config/wezterm.lua;

    file.".emacs.d/init.el".source = import ../shared/emacs.nix { inherit pkgs; };

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
        gan = "git commit --amend --no-edit";
        gpf = "git push --force-with-lease";
        gp = "git push";
        gpm = "git pull origin main";
      };

      initExtra = ''
      . "$HOME/.cargo/env"
      alias awsume=". awsume"

      e() {
        awsume "''${1}"
        kubectx "''${1}"
        kubens apps
        export GOVUK_ENV="''${1}"
        encoded_env=$(echo -n "''$GOVUK_ENV" | base64)
        printf "\033]1337;SetUserVar=govuk_env=''${encoded_env}\007"
      }

      export EDITOR="${pkgs.vim}/bin/vim"

      eval "$(rbenv init - --no-rehash zsh)"
      '';
    };

    starship = {
      enable = false;
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

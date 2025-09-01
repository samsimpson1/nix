{ stdenv, pkgs, ... }:
let
  awsumeYubikey = pkgs.callPackage ../packages/awsume-yubikey.nix { };
  awsumeOnepassword = pkgs.callPackage ../packages/awsume-1password.nix { };
  awsumeConsole = pkgs.callPackage ../packages/awsume-console.nix { };
  awsumePlugins = pkgs.callPackage ../packages/awsume-with-plugins.nix {
    plugins = [
      awsumeYubikey
      awsumeOnepassword
      awsumeConsole
    ];
  };
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      act
      asciinema
      bash
      kubectl
      kubectx
      kubernetes-helm
      oh-my-zsh
      python3
      awsumePlugins
      rbenv
      pre-commit
      tenv
      podman
      ripgrep
    ];

    file.".awsume/config.yaml".source = ./config/awsume.yaml;
    file.".aws/config".source = ./config/aws;

    file.".wezterm.lua".source = ./config/wezterm.lua;

    file."issues/issue.py" = {
      source = ./issuemaker/issue.py;
      executable = true;
    };
    file."issues/template.md".source = ./issuemaker/template.md;

    file."bin/aws-subshell.sh".source = ./config/aws-subshell.sh;

    stateVersion = "24.05";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        k = "kubectl";
        gan = "git commit --amend --no-edit";
        gpf = "git push --force-with-lease";
        gp = "git push";
        gpm = "git pull origin main";
      };

      initContent = ''
        . "$HOME/.cargo/env"
        alias awsume=". awsume"

        setopt PROMPT_SUBST
        autoload -U colors

        alias issue="$HOME/issues/issue.py"

        c() {
          awsume -c "''${1}-developer"
        }

        ca() {
          awsume -c "''${1}-fulladmin"
        }

        ce() {
          awsume --role-duration "3600" -c "''${1}-platformengineer"
        }

        govuk_awsume() {
          ''${HOME}/bin/aws-subshell.sh $@
        }

        e() {
          ENV_NAME="''${1}"
          shift
          govuk_awsume "''${ENV_NAME}" "developer" "$@"
        }

        ea() {
          ENV_NAME="''${1}"
          shift
          govuk_awsume "''${ENV_NAME}" "fulladmin" "$@"
        }

        ee() {
          ENV_NAME="''${1}"
          shift
          govuk_awsume "''${ENV_NAME}" "platformengineer" "$@"
        }

        export EDITOR="${pkgs.vim}/bin/vim"

        eval "$(rbenv init - --no-rehash zsh)"
      '';
    };

    starship = {
      enable = false;
      enableZshIntegration = false;

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

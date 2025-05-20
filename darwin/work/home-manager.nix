{ stdenv, pkgs, ... }:
let
  awsumeOnepassword = pkgs.callPackage ../packages/awsume-1password.nix { };
  awsumeConsole = pkgs.callPackage ../packages/awsume-console.nix { };
  awsumePlugins = pkgs.callPackage ../packages/awsume-with-plugins.nix {
    plugins = [
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
      podman
      ripgrep
    ];

    file.".awsume/config.yaml".source = ./config/awsume.yaml;
    file.".aws/config".source = ./config/aws;

    file.".wezterm.lua".source = ./config/wezterm.lua;

    file.".emacs.d/init.el".source = import ../../shared/emacs.nix { inherit pkgs; };

    file."issues/issue.py" = {
      source = ./issuemaker/issue.py;
      executable = true;
    };
    file."issues/template.md".source = ./issuemaker/template.md;

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

        alias issue="$HOME/issues/issue.py"

        c() {
          awsume -c "''${1}-developer"
        }

        ca() {
          awsume -c "''${1}-fulladmin"
        }

        govuk_awsume() {
          ENV_NAME="''${1}"
          ROLE_NAME="''${2}"
          ROLE="''${ENV_NAME}-''${ROLE_NAME}"

          awsume "''${ROLE}"
          if [ "''${ENV_NAME}" != "test" ]; then
            kubectx "''${1}"
            kubens apps
          fi

          export GOVUK_ENV="''${ENV_NAME}"
          encoded_env=$(echo -n "''$GOVUK_ENV" | base64)
          printf "\033]1337;SetUserVar=govuk_env=''${encoded_env}\007"
        }

        e() {
          govuk_awsume "''${1}" "developer"
        }

        ea() {
          govuk_awsume "''${1}" "fulladmin"
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

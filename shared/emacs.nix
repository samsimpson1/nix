{pkgs}:
pkgs.substituteAll { src = ./emacs.el; tfls = pkgs.terraform-ls; }

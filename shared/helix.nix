{ pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      tree-sitter = prev.tree-sitter.override {
        extraGrammars = {
          tree-sitter-terraform = {
            url = "https://github.com/MichaHoffmann/tree-sitter-hcl";
            location = "dialects/terraform";
            rev = "de10d494dbd6b71cdf07a678fecbf404dbfe4398";
            sha256 = "sha256-oRNNxE5AnI0TyJl92pk0E9xGj5xom/+0kpPMUE/O/TY=";
            fetchSubmodules = false;
          };
        };
      };
    })
  ];

  programs.helix = {
    enable = true;
  };
}

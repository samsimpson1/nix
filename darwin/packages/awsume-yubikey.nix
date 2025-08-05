{
  pkgs,
  python3Packages,
  yubikey-manager,
}:

python3Packages.buildPythonApplication rec {
  pname = "awsume-yubikey-plugin";
  version = "1.2.5";
  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  src = pkgs.fetchFromGitHub {
    owner = "xeger";
    repo = "awsume-yubikey-plugin";
    rev = "696a1cf3029cbe6126bfed1ebcb8e8c88961d1ec";
    sha256 = "OcpgfuLE5m3PjttBmcC6vYf7hrQYEZwN0xfbJ6yS46w=";
  };

  dependencies = [ yubikey-manager ];

  meta = {
    description = "Yubikey plugin for awsume";
  };
}

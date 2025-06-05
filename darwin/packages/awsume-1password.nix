{
  pkgs,
  python3Packages,
  _1password-cli,
}:

python3Packages.buildPythonApplication rec {
  pname = "awsume-1password";
  version = "0.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "samsimpson1";
    repo = "awsume-1password";
    rev = "main";
    sha256 = "RmP9bZtSf8sK48EJmCGqCW5Z/5X5dOrUWwURjbbpqiQ=";
  };

  dependencies = [ _1password-cli ];

  meta = {
    description = "1Password plugin for awsume";
  };
}

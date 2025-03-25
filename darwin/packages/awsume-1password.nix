{ lib, python3Packages, fetchPypi, _1password-cli }:

python3Packages.buildPythonApplication rec {
  pname = "awsume-1password-gaiden";
  version = "0.0.1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pBwKIbH8HbIkssUSUJpgjcpIDjnlIOVx3zp4LiK1GuU=";
  };

  dependencies = [ _1password-cli ];

  meta = with lib; {
    description = "1Password plugin for awsume";
  };
}

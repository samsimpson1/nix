{ lib, python3Packages, fetchPypi, _1password }:

python3Packages.buildPythonApplication rec {
  pname = "awsume-console-plugin";
  version = "1.2.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TOsas1nx0yCnnHUJizA0RMYFXwS5kiCFGrlo3OZVcwQ=";
  };
}

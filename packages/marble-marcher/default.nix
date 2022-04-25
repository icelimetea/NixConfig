{ lib, stdenv, fetchFromGitHub, cmake, anttweakbar, eigen, glew, glm } :
stdenv.mkDerivation (rec {
  pname = "marble-marcher";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "WAUthethird";
    repo = "Marble-Marcher-Community-Edition";
    rev = version;
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ cmake ];
  
  buildInputs = [
    anttweakbar
    eigen
    glew
    glm
  ];
})

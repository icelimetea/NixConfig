{ stdenv, fetchFromGitHub, llvm, cmake }:
stdenv.mkDerivation {
  name = "llvm-cbe";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ llvm ];

  src = fetchFromGitHub {
    repo = "llvm-cbe";
    owner = "JuliaComputingOSS";
    rev = "bc21b898326787e0dcc0e7fe0a4d001e44f9fcd3";
    sha256 = "sha256-DPovfhjVMG/TdnhE5cVgI/33KHnWYgtQTNAYiyw2O+c=";
  };

  preInstall = ''
    mkdir ./bin
    cp ./tools/llvm-cbe/llvm-cbe ./bin/llvm-cbe
  '';
}

{ stdenv, fetchFromGitHub, cmake, llvm }:
stdenv.mkDerivation {
  name = "llvm-cbe";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ llvm ];

  src = fetchFromGitHub {
    repo = "llvm-cbe";
    owner = "JuliaComputingOSS";
  };
}

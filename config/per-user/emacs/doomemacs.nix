{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation (rec {
  name = "doomemacs";

  src = fetchFromGitHub {
    owner = "doomemacs";
    repo = "doomemacs";
    rev = "731764ae7134f6ce857147f7ef067c6ce3f23abd";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r --no-preserve=mode,ownership ${src} $out

    runHook postInstall
  '';
})

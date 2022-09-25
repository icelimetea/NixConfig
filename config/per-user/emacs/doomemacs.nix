{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation (rec {
  name = "doomemacs";

  src = fetchFromGitHub {
    owner = "doomemacs";
    repo = "doomemacs";
  };

  dontBuild = true;

  installPhase = {
    runHook preInstall

    cp -r --no-preserve=mode,ownership ${src} $out

    runHook postInstall
  };
})

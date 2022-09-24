{ stdenv, pkgs, ... }:
stdenv.mkDerivation (rec {
  name = "sway-screen-size";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/

    cp ${src}/sway-screen-size $out/bin/sway-screen-size
    chmod 755 $out/bin/sway-screen-size

    runHook postInstall
  '';
})

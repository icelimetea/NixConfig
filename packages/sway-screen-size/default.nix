{ stdenv, pkgs, ... }:
stdenv.mkDerivation (rec {
  name = "sway-screen-size";
  version = "0.0.1";

  src = ./sway-screen-size;

  builder = pkgs.writeScript "builder.sh" ''
    ${pkgs.coreutils}/bin/mkdir -p $out/bin/

    ${pkgs.coreutils}/bin/cp ${src} $out/bin/sway-screen-size
    ${pkgs.coreutils}/bin/chmod 755 $out/bin/sway-screen-size
  '';
})

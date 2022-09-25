{ userName, userEmail, stdenv, ... }:
stdenv.mkDerivation (rec {
  name = "emacs-cfg";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out

    cp ${src}/init.el $out/init.el
    cp ${src}/packages.el $out/packages.el

    sed 's/\$USER_NAME/"${userName}"/;s/\$USER_EMAIL/"${userEmail}"/' ${src}/config.el > $out/config.el
    
    runHook postInstall
  '';
})

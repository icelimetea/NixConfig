{ modules, userName, userEmail, stdenv, lib, ... }:
let
  genModulesCfg = moduleAttrs:
    lib.attrsets.mapAttrsToList
      (category: moduleSet:
        ":${category} ${builtins.concatStringsSep " " (map (modName: "(${modName})") moduleSet)}"
      )
      moduleAttrs;

  genDoomModules = moduleAttrs: "(doom! ${builtins.concatStringsSep " " (genModulesCfg moduleAttrs)})";
in stdenv.mkDerivation (rec {
  name = "emacs-cfg";

  src = ./elisp;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out

    cp ${src}/packages.el $out/packages.el

    tee > $out/init.el <<EOF
    ${genDoomModules modules}
    EOF

    sed 's/\$USER_NAME/"${userName}"/;s/\$USER_EMAIL/"${userEmail}"/' ${src}/config.el > $out/config.el

    runHook postInstall
  '';
})

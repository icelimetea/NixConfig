{ userName, userEmail, stdenv, ... }:
stdenv.mkDerivation (rec {
  name = "emacs-cfg";

  src = ./emacs;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r --no-preserve=mode,ownership ${src} $out

    tee $out/config.el <<EOC
    (setq user-full-name "${userName}"
	      user-mail-address "${userEmail}"
	      doom-theme 'doom-one
	      display-line-numbers-type t
	      org-directory "~/org/")
    EOC
    
    runHook postInstall
  '';
})

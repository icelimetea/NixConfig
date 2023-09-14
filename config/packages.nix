{ nixpkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: { sway-screen-size = prev.callPackage ../packages/sway-screen-size {}; })
  ];

  home-manager = {
    useGlobalPkgs = true;
  };
}

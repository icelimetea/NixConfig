{ nixpkgs, ... }: {
  nixpkgs.overlays = [];

  home-manager = {
    useGlobalPkgs = true;
  };
}

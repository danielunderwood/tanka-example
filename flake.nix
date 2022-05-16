{
  description = "Tanka example";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    let out = system:
      let pkgs = nixpkgs.legacyPackages."${system}";
      in
      {

        devShell = pkgs.mkShell {
          buildInputs = [
            # cert-manager CLI
            pkgs.cmctl
            pkgs.jsonnet
            pkgs.jsonnet-bundler
            pkgs.nixpkgs-fmt
            pkgs.tanka
            pkgs.yq
          ];
        };

      }; in with utils.lib; eachSystem defaultSystems out;
}

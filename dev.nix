{ pkgs }:
let
  # need to match Stackage LTS version
  # from stack.yaml snapshot
  hPkgs = pkgs.haskell.packages."ghc928";

  # Wrap Stack to work with our Nix integration. We don't want to modify
  # stack.yaml so non-Nix users don't notice anything.
  # - no-nix          # We don't want Stack's way of integrating Nix.
  # --system-ghc      # Use the existing GHC on PATH (will come from this Nix file)
  # --no-install-ghc  # Don't try to install GHC if no matching GHC found on PATH
  stack-wrapped = pkgs.symlinkJoin {
    name = "stack"; # will be available as the usual `stack` in terminal
    paths = [ pkgs.stack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/stack \
        --add-flags "\
          --no-nix \
          --system-ghc \
          --no-install-ghc \
        "
    '';
  };
in
{
  # languages.haskell.enable = true;

  # https://devenv.sh/reference/options/
  packages = [
    stack-wrapped
    hPkgs.yesod-bin # Yesod command line tool
    hPkgs.ghc
    hPkgs.hoogle
    hPkgs.haskell-language-server
    # hPkgs.fourmolu
    # hPkgs.retrie # Haskell refactoring tool
    # hPkgs.cabal-install
    # hPkgs.ghcid # Continuous terminal Haskell compile checker
    # hPkgs.hlint # Haskell codestyle checker
    # hPkgs.implicit-hie # auto generate LSP hie.yaml file from cabal

    pkgs.zlib
  ];

  # # processes example
  # processes.hello.exec = "hello";

  scripts = {
    # dev-install-osmosis.exec = "curl -sL https://get.osmosis.zone/install > i.py && python3 i.py";
  };

  enterShell = ''
  '';
}

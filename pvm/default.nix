{ mkDerivation, aeson, base, directory, filepath, lib, mtl
, optparse-applicative, tasty, tasty-hunit, text, transformers
, yaml
}:
mkDerivation {
  pname = "pvm";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base directory filepath mtl optparse-applicative text
    transformers yaml
  ];
  executableHaskellDepends = [
    aeson base directory filepath mtl optparse-applicative text
    transformers yaml
  ];
  testHaskellDepends = [ base tasty tasty-hunit ];
  license = lib.licenses.mit;
  mainProgram = "pvm";
}

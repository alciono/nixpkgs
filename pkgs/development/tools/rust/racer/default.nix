{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = version;
    sha256 = "06k50f2vj2w08afh3nrlhs0amcvw2i45bhfwr70sgs395xicjswp";
  };

  cargoSha256 = "1w5imxyqlyv24dvzncq6dy01zn2x8p1aciyvzh8ac1x1wdjcacjc";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rustcSrc}"
  '';

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustPlatform.rustcSrc}"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}

{
  lib,
  fetchFromGitea,
  clangStdenv,

  meson,
  clang,
  ninja,
  reoxide,

  libllvm,
  libclang,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "reoxide-plugin-simple";
  version = "0.6.1-unstable-2025-08-27";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ReOxide";
    repo = "plugin-template";
    rev = "a8457da854c7ba0908c88c58a251b6398ba410f3";
    hash = "sha256-y9gxryOp1JdM5ttrIP5lge55UZS5hL5RIqLNRE98XFA=";
  };

  nativeBuildInputs = [
    meson
    clang
    ninja
    reoxide

    clangStdenv.cc
  ];

  buildInputs = [
    libllvm
    libclang
  ];

  env = {
    CC = "${clangStdenv.cc}/bin/clang";
    CXX = "${clangStdenv.cc}/bin/clang++";
  };

  mesonFlags = [
    "-Db_ndebug=true"
  ];

  configurePhase = ''
    runHook preConfigure
    
    mkdir -p .config/reoxide
    touch .config/reoxide/reoxide.toml
    export HOME=$PWD
    
    meson setup --buildtype=release $mesonFlags build
    
    runHook postConfigure
  '';

  meta = with lib; {
    description = "Simple plugin template for reoxide";
    homepage = "https://codeberg.org/ReOxide/reoxide";
    license = licenses.asl20;
    maintainers = with maintainers; [
      themadbit
      eljamm
    ];
    teams = with teams; [ ngi ];
    platforms = platforms.linux;
  };
})

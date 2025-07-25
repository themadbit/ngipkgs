{
  lib,
  pkgs,
  fetchFromGitHub,
  buildNpmPackage,
  puppeteer-cli,
  nix-update-script,
  nodejs_22,
}:

buildNpmPackage (finalAttrs: {
  pname = "pagedjs-cli";
  version = "0.4.3-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "pagedjs";
    repo = "pagedjs-cli";
    rev = "d682e19ee5d14bfe07ad1726540e2423ede75a05";
    hash = "sha256-7DXfBMi6OPNUT1XM5Gtsbk8xK4rz5xmDbJAPulrVTmE=";
  };

  npmDepsHash = "sha256-QX7TkGQ47UunRjsRHn5muE1a6X84GZyHdCEa+blx9Ik=";

  # Skip Puppeteer's Chrome download during dependency installation
  preBuild = ''
    export PUPPETEER_SKIP_DOWNLOAD='true'
  '';

  npmInstallFlags = [
    "--ignore-scripts"
  ];

  nativeBuildInputs = [
    nodejs_22
    puppeteer-cli
  ];

  meta = {
    description = "Command line interface for Pagedjs";
    homepage = "https://pagedjs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ themadbit ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.all;
    mainProgram = "pagedjs-cli";
  };
})

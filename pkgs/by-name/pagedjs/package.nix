{
  lib,
  pkgs,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  nodejs_22,
  makeWrapper,
  chromium,
}:

buildNpmPackage (finalAttrs: {
  pname = "pagedjs";
  version = "0.5.0-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "pagedjs";
    repo = "pagedjs";
    rev = "c71f8ab56905168abafa31b7c2329d7f9c1b1dc8";
    hash = "sha256-7DXfBMi6OPNUT1XM5Gtsbk8xK4rz5xmDbJAPulrVTmE=";
  };

  npmDepsHash = "sha256-QX7TkGQ47UunRjsRHn5muE1a6X84GZyHdCEa+blx9Ik=";

  # Skip Puppeteer's Chrome download during dependency installation
  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  npmInstallFlags = [
    "--ignore-scripts"
  ];

  dontNpmBuild = true;

  # postInstall = ''
  #   wrapProgram $out/bin/puppeteer \
  #     --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  # '';

  nativeBuildInputs = [
    nodejs_22
  ];

  meta = {
    description = "JavaScript library for paged media in the browser";
    homepage = "https://pagedjs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ themadbit ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.all;
    mainProgram = "pagedjs";
  };
})

{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "actiongraph";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "icio";
    repo = pname;
    rev = "3cf5d9b3415761ba1efef5d97b2289f4190e0b8c";
    hash = "sha256-EaX8xLDViUsXrkbQ+wM4OdkgL6iVRhZSH4ZT44Cnwj8=";
  };

  # # The tests will fail because spkit cannot run without a home
  # doCheck = false;

  vendorHash = "sha256-C1LdcC/SrtpsDdHN+JlKxeOP33FkA3AVixYX063OFTI=";
}

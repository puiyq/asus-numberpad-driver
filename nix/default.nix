{
  lib,
  python3Packages,
  makeWrapper,
  xinput,
  i2c-tools,
}:

python3Packages.buildPythonApplication {
  pname = "asus-numberpad-driver";
  version = "6.8.5";
  pyproject = false;

  src = ../.;

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    libevdev
    xlib
    pyinotify
    pyasyncore
    xkbcommon
    xcffib
    python-periphery
  ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # Install layouts as Python module
    install -Dm644 layouts/*.py -t $out/${python3Packages.python.sitePackages}/layouts

    # Install executable
    install -Dm755 numberpad.py $out/bin/asus-numberpad-driver

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/asus-numberpad-driver \
      --prefix PATH : "${
        lib.makeBinPath [
          xinput
          i2c-tools
        ]
      }"
  '';

  meta = {
    description = "Linux driver for NumberPad(2.0) on Asus laptops";
    homepage = "https://github.com/asus-linux-drivers/asus-numberpad-driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "asus-numberpad-driver";
  };
}

{
  lib,
  python3Packages,
  makeWrapper,
  xorg,
  i2c-tools,
}:

python3Packages.buildPythonApplication rec {
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

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    # Install layouts as Python module
    install -Dm644 layouts/*.py -t $out/${python3Packages.python.sitePackages}/layouts

    # Install data files
    install -Dm644 laptop_numberpad_layouts laptop_touchpad_numberpad_layouts.csv \
      -t $out/share/asus-numberpad-driver

    # Install executable
    install -Dm755 numberpad.py $out/bin/asus-numberpad-driver

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/asus-numberpad-driver \
      --prefix PATH : "${
        lib.makeBinPath [
          xorg.xinput
          i2c-tools
        ]
      }"
  '';

  doCheck = false;

  meta = {
    description = "Linux driver for NumberPad(2.0) on Asus laptops";
    homepage = "https://github.com/asus-linux-drivers/asus-numberpad-driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "asus-numberpad-driver";
  };
}

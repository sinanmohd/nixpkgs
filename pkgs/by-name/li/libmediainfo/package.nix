{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, zlib }:

stdenv.mkDerivation rec {
  pname = "libmediainfo";
  version = "24.04";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    hash = "sha256-dqb/BgiHdz8ll3tYiuUISEuxLRHLeivjMi2qnG5T8bI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ libzen ];

  sourceRoot = "MediaInfoLib/Project/GNU/Library";

  postPatch = lib.optionalString (stdenv.cc.targetPrefix != "") ''
    substituteInPlace configure.ac \
      --replace "pkg-config " "${stdenv.cc.targetPrefix}pkg-config "
  '';

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    changelog = "https://mediaarea.net/MediaInfo/ChangeLog";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}

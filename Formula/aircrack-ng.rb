class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  url "https://download.aircrack-ng.org/aircrack-ng-1.5.2.tar.gz"
  sha256 "9e592fe7658046220e0ac0a6d05c4026903f3077b248893e0056ccbe4ee88241"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "772e69403efdced2c6482abb1d118bb848d5d033156f64d6d5807e4205028399" => :mojave
    sha256 "ef9b3527b33cfdff40e21e8b678921dfbd411d0be586b5fede62a039a0d50d1f" => :high_sierra
    sha256 "620b3b925934f2a9fdeee038d9f00983c413ae098a65d26552bb61b4411c434c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "sqlite"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    system "./autogen.sh", "--disable-silent-rules",
                           "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--with-experimental"
    system "make", "install"
  end

  def caveats; <<~EOS
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
  EOS
  end

  test do
    system "#{bin}/aircrack-ng", "--help"
  end
end

__END__
--- a/scripts/airodump-ng-oui-update
+++ b/scripts/airodump-ng-oui-update
@@ -20,25 +20,6 @@ fi

 AIRODUMP_NG_OUI="${OUI_PATH}/airodump-ng-oui.txt"
 OUI_IEEE="${OUI_PATH}/oui.txt"
-USERID=""
-
-
-# Make sure the user is root
-if [ x"`which id 2> /dev/null`" != "x" ]
-then
-	USERID="`id -u 2> /dev/null`"
-fi
-
-if [ x$USERID = "x" -a x$(id -ru) != "x" ]
-then
-	USERID=$(id -ru)
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-
 
 if [ ! -d "${OUI_PATH}" ]; then
 	mkdir -p ${OUI_PATH}

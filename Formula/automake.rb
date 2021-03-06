class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.tar.xz"
  sha256 "f98f2d97b11851cbe7c2d4b4eaef498ae9d17a3c2ef1401609b7b4ca66655b8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8135f20535b5b225c082106b005d85aa280010b1c1eeedb56d456b6e3478359a" => :high_sierra
    sha256 "8135f20535b5b225c082106b005d85aa280010b1c1eeedb56d456b6e3478359a" => :sierra
    sha256 "8accb0115d48ed86969fb4591bd911dded858fba5346f76715e9cd7233ce21ba" => :el_capitan
    sha256 "452c4e47b09bfa3709a6e0fccd91200fe5cec19685fad4fccca77288446161ba" => :x86_64_linux
  end

  keg_only :provided_until_xcode43

  depends_on "autoconf" => :run

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end

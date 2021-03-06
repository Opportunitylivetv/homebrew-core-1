class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.23.0/fonttools-3.23.0.zip"
  sha256 "9af97075be0395b631880a82ba88dcf694c8aa76b07a622bf5f650e8f8cff293"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0436c59dc2f262ac2157e49ffb96b67947ddc0c8eaaebb959e902999cd5bf08" => :high_sierra
    sha256 "7e94717fb5591da52656ebe6f5ac8c715de35c69e7bc8c97d6c53de2a82bb9bc" => :sierra
    sha256 "0a4fa59a945005c6d129c1c83c0b1f503e6dd8b116ad03bb059e94c361c036f4" => :el_capitan
    sha256 "6c942134fadad3ce0d5650536acf8ec9635421a7aaf0bf400f819e8cd2851199" => :x86_64_linux
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end

class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"

  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8c99ba985ed4102767beb1413508731726f78ab7329e192cd54461f5d5c78856" => :high_sierra
    sha256 "f1f78c46406518bfb8197922d199737d5ae44913e86e1753df84a759c6670556" => :sierra
    sha256 "0e597243f20f7a5a0699d72dcd4d0395976e481a1fc32c24725c2a4b4fee6992" => :el_capitan
    sha256 "24a9edea9e97823c333d0352244d7b30f72ddb0c8df291706463f8c76a0ca2e9" => :yosemite
    sha256 "47d5c12604878a2f3eb75da8c80a15d991b47129a17684fde8f02fe97f16e78b" => :mavericks
  end

  conflicts_with "choose-gui", :because => "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/source/u/urwid/urwid-1.2.1.tar.gz"
    sha256 "9b9b5dabb7df6c0f12e84feed488f9a9ddd5c2d66d1b7c7c087055720b87c68c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("urwid").stage do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end

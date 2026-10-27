class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b062b336a85bf290344fe4efb730468fd8bda6941e508bf76150a3afb6a9a2d6"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/fresh-editor-0.5.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "09f34a309c20cea4fe2f8de5c47892c3f3817c7c8ae0b7158f7beaf65e288a00"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end

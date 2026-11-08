class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "b048bfa38b9b50a262f19ac49d254a1479926ddb74d496367649892ac8720495"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/fresh-editor-0.5.8"
    sha256 cellar: :any_skip_relocation, sonoma: "fe0624640e7cb645fbf5c291e2d2ab5601834c91145b6599dbbf2ad31d2c6ac2"
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

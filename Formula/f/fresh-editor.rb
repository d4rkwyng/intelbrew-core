class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3ab409970e18e692ed7a046bc0c27f4a68119858928e4b4b499e992dc7a0a118"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/fresh-editor-0.5.7"
    sha256 cellar: :any_skip_relocation, sonoma: "58ea709a6167c844c3a0ec80edad5304620fd200385fdff10b47320d87a8ea52"
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

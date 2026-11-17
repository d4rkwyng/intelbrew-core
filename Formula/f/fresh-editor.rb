class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "87cbbf4c0dd25ad1db7f59681319f324b3e1f6b472e41f6c04bab17ebe0ffda3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/fresh-editor-0.5.9"
    sha256 cellar: :any_skip_relocation, sonoma: "12dee8a0c45ba524f34ce8a31ea76faa6eafad62ef71d0dd9fb6a8e8df1dac76"
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

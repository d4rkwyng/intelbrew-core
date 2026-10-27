class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  # TODO: Migrate to `openssl@4` after https://github.com/mozilla/sccache/issues/2780 is resolved
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2da079033cd19fd8e2a09f56f9a7d9d1a72d591ff3acdc47d95b920145cf2671"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/sccache-0.19.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "f63a90811956c44500b9e86677f84158a4c3045ea249acb4e084e5a8bad6a360"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  # `test do` block starts a local sccache server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "all")
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end

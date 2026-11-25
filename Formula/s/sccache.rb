class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "1568b19b3e9bcf911986670dbf92264100974319ddde0b1ccaeecfa82b953632"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/sccache-0.20.1"
    sha256 cellar: :any_skip_relocation, sonoma: "33b3943e2ffcc90b96c3732362b8ec275b6c0f1f621440789f873142e6394373"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
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

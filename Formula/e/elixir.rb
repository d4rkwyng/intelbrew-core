class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "2f87be1702583ecbeee82c0ad4d6353de96463cfa0fa6e7557e05f68d90da869"
  license "Apache-2.0"
  compatibility_version 6
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/elixir-1.20.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "814d86f222fd18f46950ea574e343478b37f67a5336519e08a60df11ce2a31c2"
  end

  depends_on "erlang"

  deny_network_access!

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end

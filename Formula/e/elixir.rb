class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.5.tar.gz"
  sha256 "3d99f2e129418800817e0e5a3ce4812c34537a32d50e37578189e90c79de7062"
  license "Apache-2.0"
  compatibility_version 6
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/elixir-1.20.5"
    sha256 cellar: :any_skip_relocation, sonoma: "34dee6d84d0f4f50daff74b4acc849951ffee6f1be600b23060f1bb31a20f13c"
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

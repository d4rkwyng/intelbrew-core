class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "8da0e478a6027803043149c63c84abbb0dd4b3538372b8d854c2f8cab8215f41"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/dysk-3.8.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "ac2b84a1cac2df3dc491923a58af5b5beceed72fa31110f983740122505fbc5e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end

class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "3e82c5d1624bf30a8c71e56f879d7e1af85c1a0a957d7a47ffa1194dbc281ea3"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/dysk-3.8.2"
    sha256 cellar: :any_skip_relocation, sonoma: "99bc4bc04158e4370a42821f16847551a8bf74685fc1b35e5d0b624e52940038"
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

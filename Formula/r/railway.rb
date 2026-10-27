class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.71.0.tar.gz"
  sha256 "953b79a2d4422344a64ef2929487a66ebc3e1f67b4024116a55c8da8eebffba3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/railway-5.71.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "c73dc238de2651f87aae2917603e51bfd4930fa1af07efe6ffafa2b7d65f99bb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end

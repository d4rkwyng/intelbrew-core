class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "88704a28231ac0019016c1900edebc9dea0cf14de4e5bc90aa96fd594925bdc0"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ipatool-2.8.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "0644a8f2c4fb2bfdbc6df18e6e709ef21e9ad332179a526c7f58e96af380528e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end

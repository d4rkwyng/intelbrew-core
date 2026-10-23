class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "8f88d20bf971d6edbb8780cff8f76c1c565e9f352f21f6da0c6ac48003b3189d"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ipatool-2.7.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "b5ed5ad316481549b63cf3108ded73bd96011ce95a797dfed3f01b4338214f2b"
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

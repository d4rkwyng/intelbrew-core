class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0191aac329e749b4ccc2e94ae56b5d1fc27caf3269d37bb7e5114329ebd7211e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/sqlcmd-1.11.0"
    sha256 cellar: :any_skip_relocation, sonoma: "f48c78071ccc8bd296d8630ae9d8a5a88e7f329816baa60c80156d5674448968"
  end

  depends_on "go" => :build

  # `test do` block expects `connection refused` from a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", shell_parameter_format: :cobra)
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end

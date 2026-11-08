class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "eb9d85a95da1c391b5b5dfcb4ce6c745a937bbe14155297a60c81c7610d9fa66"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/temporal-1.10.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "8935167f6d52a7bf5be76902e51a69161fe9c3dc771a36334ba7a4ccd9705127"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/temporal --version")

    assert_match "failed connecting to Temporal server",
      shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
  end
end

class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.165.4.tar.gz"
  sha256 "a57ca094478833263d528f2effaa82290c4c5bc7e11bc9051eb27e78351cc735"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "532a13b9a4b3396be8ff495806555fd0f12eb98baf12a9b31b0f5ee8e9ef6990"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "532a13b9a4b3396be8ff495806555fd0f12eb98baf12a9b31b0f5ee8e9ef6990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "532a13b9a4b3396be8ff495806555fd0f12eb98baf12a9b31b0f5ee8e9ef6990"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1287d57e610add6820e8d1b47dfd1beacc907507ac4e7fa8ed1dfe22aff8c9e8"
    sha256 cellar: :any,                 x86_64_linux:      "750be2be31ec0948bc5f3985988f6f94bb19568c3979c5c437ed1273cd04b5e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end

class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "c3bfb10030df2b4cad909e26aa4a1f003dd1d0a829e7001de57d3e3074822cb6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/cloud-sql-proxy-2.28.1"
    sha256 cellar: :any_skip_relocation, sonoma: "98ac241eb0b53496b4eb2b390f139aa4a79f9bc898e4eaee03feffe8e027fb45"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end

class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.70.0.tar.gz"
  sha256 "38e100862d8648c9afbe0ce78d328c1934c2774ced63ea7e6d8ecc35de377d60"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/mole-1.70.0"
    sha256 cellar: :any_skip_relocation, sonoma: "dd415fb3b501507c6c68b0f5387d099bfa109068690d23be2b1b007bc5bf76bc"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)

    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    libexec.install "mole", "bin", "lib"
    bin.install_symlink libexec/"mole"
    bin.install_symlink bin/"mole" => "mo"

    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    # Point simctl at the CLT so the sandboxed Xcode simulator probes are skipped
    ENV["DEVELOPER_DIR"] = "/Library/Developer/CommandLineTools"
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end

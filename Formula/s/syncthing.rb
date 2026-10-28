class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "e9794cab0adf5b0a59d9b631e994dce055c57cb805228555bdfa68118be4bd0a"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/syncthing-2.1.7"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "a8275a4f9ece7b16bb2b85824166827e3ba2a9b0ca1e9738a6e32a29ff15005a"
  end

  depends_on "go" => :build

  # `test do` block binds local ports for config generation
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end

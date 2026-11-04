class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "596e702c00a25a19dc25d7734ba56922ed6857252fc474a787fe271d0d42d4ec"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/prek-0.5.10"
    sha256 cellar: :any_skip_relocation, sonoma: "d2269f767a7ff2e835bdc7e769992f10bdbb89ca4506cf5146ee4fc6b37308b2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end

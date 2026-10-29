class Act < Formula
  desc "Run your GitHub Actions locally"
  homepage "https://nektosact.com"
  url "https://github.com/nektos/act/archive/refs/tags/v0.2.91.tar.gz"
  sha256 "a390ab57f06368f131abcdc2f039a5cac6df9617673eccd8c4eadfd97b6d3fb2"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58ffb5490f02656d558315e59af6a1d796d947872029514c9181b95d24066195"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8d9a65a2323a8c074c4ebea407a5d43347ae57d51eab8fe9519c7481bb37fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e90e3807ce95ae89401eebe47b3407f7f0af530fd4d56f86cf256d142e8785e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6982d99e51cd4a152fc60f8b371a1c73c36a0cd7490d1ae38eac9af3afdadd23"
    sha256 cellar: :any,                 x86_64_linux:      "96aacff7b06b9ce97dc33c4ccd4bb1fcdd8d4e77c3581e13a5620c8c2bbf63c5"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall]

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"

    generate_completions_from_executable(bin/"act", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end

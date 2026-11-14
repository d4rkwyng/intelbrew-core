class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.3.2",
      revision: "8346aaa55e7161f7c547212d0a87f01367976727"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/helm-4.3.2"
    sha256 cellar: :any_skip_relocation, sonoma: "28d60b75e6b5a25815e4dd3b076414ecaf117a54f3b7ffa2e29de3d8467c73f8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `make build` runs `go mod tidy`, which needs the full module graph
    system "go", "mod", "download", "all"
  end

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", shell_parameter_format: :cobra)
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end

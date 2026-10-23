class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a52cc7d61f8b2f043b7f0be1febecead5fceb791543c4790d699440f12d6b370"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/crane-0.22.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "891dbf43b8f5ed5a640d12c8ca315f059a6f95ef8b017bb32e7ea6dfe4f47554"
  end

  depends_on "go" => :build

  # `test do` block fetches a manifest from gcr.io
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", shell_parameter_format: :cobra)
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end

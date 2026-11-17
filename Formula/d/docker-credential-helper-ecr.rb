class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "95478189f2a3dc6a89f3f047348f4e64443089c0574f6ec0bd864ef44f098bf4"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/docker-credential-helper-ecr-0.13.0"
    sha256 cellar: :any_skip_relocation, sonoma: "f9dbbe8db39fda0495ec16eb88b70749112015c6d5f2d3026d56975513fe6d61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "ecr-login"
  end

  def install
    (buildpath/"GITCOMMIT_SHA").write tap.user
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match(/^Usage: .*docker-credential-ecr-login/, output)
  end
end

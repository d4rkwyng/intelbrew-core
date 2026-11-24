class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "dddc4b80ce9e21fe8ac585cf9693e4b3b092986fb260303ad2437330648e2af5"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/kevinburke/go-bindata.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/go-bindata-4.0.3"
    sha256 cellar: :any_skip_relocation, sonoma: "63c158636998127e636dc5983fcbd8212c5eb95e2510ab5f90080b98e82a3730"
  end

  depends_on "go"

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    File.delete(testpath/"data")
    assert_path_exists testpath/"data.go"

    (testpath/"testbindata.go").write <<~GO
      package main

      func main() {
        println("data:", string(MustAsset("data")))
      }
    GO

    assert_equal "data: hello world", shell_output("go run data.go testbindata.go 2>&1").chomp

    assert_match version.to_s, shell_output("#{bin}/go-bindata --version")
  end
end

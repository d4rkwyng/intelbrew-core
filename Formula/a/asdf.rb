class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "29f5b702f532f345270e2f7bb8b01ea07dbc6892e34ec8c97a180002794684e3"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/asdf-0.20.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "13e085cbf4645d3413ba1a3765a7fdb2dde235627669c817b3c339e389b631dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # fix https://github.com/asdf-vm/asdf/issues/1992
    # relates to https://github.com/Homebrew/homebrew-core/issues/163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end

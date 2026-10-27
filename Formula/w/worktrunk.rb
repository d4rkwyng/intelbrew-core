class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "ab5cbc30f9b07b2ccb2133813f100deda77731dad0ce440332a34090de165d2d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/worktrunk-0.81.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "d53661dc12b3b3c147b3a0456946eede496b1716285df98286eb6bf7e7c39e5c"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["VERGEN_GIT_DESCRIBE"] = "v#{version}"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end

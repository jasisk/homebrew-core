class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "33a01584aa8550875eef9376eb8c4bfda5429602b26a5eed0708653f67016f9a"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5186538b6e6462d00f54765360fbd703c94675de4a40ec777f7246d0de48c63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89222ce1059d60203baa678632c38c50c1c9d405ff468e2656da2ab5ae136eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c22939c469b839f4fe7726f52a7e35ad10e92bb29bcfced766eb95623fa71ce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6946e74dbf96530fb947e7abced13b7ebd8df6e7f4c31193e3fa857d4a53c286"
    sha256 cellar: :any_skip_relocation, sonoma:         "daf675193e2abcc21702c03a86a9ff8f8874fe8ff552ab8f8ec191f55cd936ec"
    sha256 cellar: :any_skip_relocation, ventura:        "d2684bc20e92cf305780acc5c5e9f746f98b58822d56093d1e3f7a2a3ee869a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ccdeaf914d5828682b6b231136a6c9e33756e8c386d319bdcc00de73186f2b54"
    sha256 cellar: :any_skip_relocation, big_sur:        "7edc59ea4b41d6adeb55362f88b48490d6558b82ec0ea466d4c8c870e214b356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb96b99ecc9cfa050ab3dd53d45aa8958eb4618f8d68f8991a919e4a621eed3c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to decrypt/read env file talenv.yaml", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end

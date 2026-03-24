class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "1b7b507b26d1538eded66eb1925ea6898ae57ca0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "#{BASE}/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "#{SHA_MACOS}"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "#{BASE}/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "#{SHA_LINUX_X86}"
    elsif Hardware::CPU.arm?
      url "#{BASE}/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "#{SHA_LINUX_ARM}"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

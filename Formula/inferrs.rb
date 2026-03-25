class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "d97e5428d55032d7982525d57e34c49d4f901e59"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "fd207d9608e0e4e94f4a32d03e2eb4176f79353318ab90c57d3549679b1f6e0f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93cf384a9565ec52b0541eced196ad6e9163d5cd182ba694149695b81e585698"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ad4453bd019a19a8f333059b8b10b97492635b5631c0bd4f942d91afa556fbd9"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

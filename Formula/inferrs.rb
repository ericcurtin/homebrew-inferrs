class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "65c35c7dae1a2e480756f61438b562d2f8574165"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "ac7b20b08940b5356a5ab777279dc378b0c6a715b127df4315699ea2ff32963a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "403e8b7effe177d69f360eb3c1015a12c920350c88436ffaae250b348c764452"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f84323a5a24d0f7c652f97e4addecd86607274fb883ea1083ffb12a0debe8826"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

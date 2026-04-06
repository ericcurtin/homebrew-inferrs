class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406212148"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406212148/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3947c42a058c326ba90f21b54aefeb8f49e342aed9a51a764893de919ea1dd0f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406212148/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66ff104580522e70f0875a2ed02f124d1936635a031a68788a7756c15b9f7391"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406212148/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92530460c3e71125284a3307ab0918d40ce10b8b357166c1763a0e1d2c5ee874"
    end
  end

  def install
    bin.install "inferrs"

    # Install GPU backend plugins alongside the binary so the
    # inferrs binary can find them via dlopen at runtime.
    %w[
      libinferrs_backend_cuda.so
      libinferrs_backend_rocm.so
      libinferrs_backend_vulkan.so
    ].each do |plugin|
      bin.install plugin if File.exist?(plugin)
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

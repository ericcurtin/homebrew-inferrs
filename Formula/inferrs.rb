class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406111456"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406111456/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "6483b4ebf568026d74b2f0b826196a1e51a9bc7d9f4526f12443b1cc4c6b4250"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406111456/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc7ce11c1a2aebf65e7f7bd9a109d1739e78cd20c56e90dcad0cdaddce6b84d6"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406111456/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0189bc6586aa849ceb3cc4b50c6145f6098fe5872665e7fb993dde0127f7dc0e"
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

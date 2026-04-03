class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260403204549"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403204549/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "9e920a86f10d0fa54e403c4e35db46117a3980fa77735a89d3f3ecb8d9041dce"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403204549/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89663b0305b78357670a80d06d309cea1598081f10000e000fa062622e449a9b"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403204549/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "42582218ed5dfa44301056a9d2e0c2031915babeb83195de29acd34ab529a7f3"
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

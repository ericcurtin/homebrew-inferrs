class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408121707"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408121707/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "bf5230372b0c5bc8d2c3d7efd4f36f772ed3e6c261d3eebb39f17610d05260ca"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408121707/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "75d40a68505fcf0a39520a6827601113a05a48e4dfe71d281c8a459ba3e20333"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408121707/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f23898608375b5f3998db73b8a7e59e563c6c94b1d91190fdbf8652cfdad10fc"
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

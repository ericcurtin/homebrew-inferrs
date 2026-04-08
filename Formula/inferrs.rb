class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408004248"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408004248/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "da45642518043f1b8c20ba9410d61e02626cc9ac34b3dca1cdb4341d3c3914ab"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408004248/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f89595f741405f36eaa758e33ad426412441f1f95533c44cfc309339744e1d6b"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408004248/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c236e1cba8f8148267729cf4c9e6fd1f7d02c0135afe1f1d4e47a4e8fb95c37f"
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

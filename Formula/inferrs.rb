class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260407181247"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407181247/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "991a5e4b2003f68e77a7ccecf3abd618c4ec6f1205ea0c9d9d2bf6cdcdc5ac6c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407181247/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "100e84eec5f9fcf4c9b81d62c6545b6c725f035e0d722c93ee7dce5b465a1e0f"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407181247/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0fdf96ac2c7149fb10e8b5018f33db9a893f09d634d25cd85d33ec2db7ab9c1c"
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

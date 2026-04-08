class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408113027"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408113027/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "cd0a1de4f7cf0fcf3b87a574a541d26d48f1323e4d027a996c9f58e915bc6b7b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408113027/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af71b9685c89405cf5e40c2af3ed7f15fee295f42ffe0582cffbde208a3e6780"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408113027/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3367e5be835e91259727c6444ffac6993b89fe70441f85e7f1e55db759c68748"
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

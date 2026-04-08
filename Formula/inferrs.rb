class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408122503"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122503/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d9c1007000ce2a97c9a736d4d1edcf555db994d151a9b32f4c5176fb258738f0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122503/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "796665548513fd207d52811c4b6809ea18caaefd370b8e6960e1da01e162fce3"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122503/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6fffce83df7f45fbb8b309bb6fcb9d5441a59c71965e9326316f81b6e72e9ad0"
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

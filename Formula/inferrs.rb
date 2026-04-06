class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406130122"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406130122/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "12f4a5af35cbc22d73e9d0b831ee5ab15de19b03ad12c15b1e7116e70ea65d68"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406130122/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53e246ad6dd892d43e18a8c969b0d14916bcfbc75bffee471f7bdd9ff7b634fd"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406130122/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1635f3a293399b7a0d2392f078ef3bbee4ff83062ea584fb724fac4cede40539"
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

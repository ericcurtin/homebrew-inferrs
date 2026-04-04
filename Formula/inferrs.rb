class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404203743"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404203743/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "b8c9df9479ffff681d5d0b1f296377e107b8ff5c183cc99a1f547ad998d17fe0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404203743/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27b5ddbab55e1758d7113476bb0dd6f47e9a67309dea0ab637bcffac86445725"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404203743/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2057fea7d182ee8380521371c0a299fb4c3192d9accd961acac3a03125b8a3d0"
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

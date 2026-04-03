class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260403202321"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403202321/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "dc72e7ff2ba9863478d1a1b60afbf4d6ae9c312f69b660bbd2a908aca7dda557"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403202321/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57326200478e4f2690bcfe47eb4403b98b6a383b51cd8dff5a2351501f02f4f2"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260403202321/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c90b6ed4180e11d7ccfc58c37e001cca69647662a277a499c8d55d70e254a98f"
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

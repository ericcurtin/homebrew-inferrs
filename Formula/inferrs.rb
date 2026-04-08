class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408161442"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408161442/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "5035d9c81626c4b28109c4c53134cc191959a2c69529c0d56652b78342969eeb"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408161442/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c61f245ea8f5d7865a4de923b2c377302f82e7d5fe896800dfab4a520cb64c5"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408161442/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bcaea48e71423e9392d61c1bd6e81e72c2370988d580456784d36b779af566e7"
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

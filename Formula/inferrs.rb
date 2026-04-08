class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408145534"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408145534/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d4da130b4c160c9ca49108893883a53032148f8439c1697383cb1b6221cda539"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408145534/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a96f1d3ab93e12ec7cbd0d40faa9c6b0ce4b38209e643479437802c7b3467753"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408145534/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb646dd2c4031de44b88488f3a03aabc73d129550c8e89227904435d1bb4ddfe"
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

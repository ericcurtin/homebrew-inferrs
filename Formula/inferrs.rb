class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404172514"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404172514/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "63c7c8349721941b7c4b48e137516a5437195ffdd5d66cf4c37ee5c5462d96aa"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404172514/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b15f320e4ce4b133138992de0675426ba6b43f7a4e540fc207f86287a24339a0"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404172514/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "438635b9b40da49649e0dd3ee00badec178cf5e9fe7a27475f6b395ddb7d1f80"
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

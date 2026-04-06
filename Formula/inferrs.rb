class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406122931"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406122931/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d17530f3c14b7522f01ad74912cdb6699ad9109aaf55a8107453e64f72694afe"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406122931/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a71aad02efcaded375a4f6d070783d7408bd08fd841a644ada8a42e116b2f57e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406122931/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8aa26173fee7d739c5f09a2091f03c2421973a0794cf828e4704190ebd941497"
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

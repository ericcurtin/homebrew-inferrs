class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406221324"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406221324/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "a2bacb55b0e048a14c3296c654e321356c9ec2f78bf5890b78704cb00f996c1d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406221324/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c6e6622cb198f2aa464468af50d6c54d8297e64c4c5845759af8cf7bf3aaf0c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406221324/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0d951563089c6b1f1b9613bc26af0c819432b4cae44b0aa9d78cc95b38a928f2"
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

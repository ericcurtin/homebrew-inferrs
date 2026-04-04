class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404124207"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404124207/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "cfd2963c14bb7b4e276064e5f67df1a83eb4526aee3116088803c52946775a0f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404124207/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4733f00e60ed5c59cd7c8a2031820c72e6edbbbfd24c77b4c91c1ce7c063c54f"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404124207/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b51b371f45cb3465b60abb226593a64059d166069614ff86d8d4fd2debedb7ab"
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

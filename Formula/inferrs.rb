class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408153119"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408153119/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "a2cea6f6bf4e11471d6a363617baf9e8f57b346a49cf635971da402bfe940c4b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408153119/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e3aa9c246ed8c4cd0b28fe2babe2151f3dbff8df3f28974a05bfcbe37fba403"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408153119/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8363ddfc4383c793b29f4ff733d18d3631be11c51ad02bb67f1683fff6c401bd"
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

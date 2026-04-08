class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408213523"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408213523/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "987c830570872efa0048aa3d98f4e780ad1db1bd4d1e02afb763d5683ad41588"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408213523/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b1938eb6977d415ba33687030dd29dbdf5349fd95c5524f68037dbb57f894b7"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408213523/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6744ed25b184e170b64c8aae3af8fabbc718ac5c2b42bcf51a41f795831513ee"
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

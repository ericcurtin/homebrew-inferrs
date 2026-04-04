class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404122136"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404122136/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e0b3ed87dd0a2977c388b6906e10dd1602b3c29dd1c436e8796994cc2da6b773"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404122136/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c3dbb50a57cee2cb59a38c8eb13363d8205364b42cecc9273f367d7ebd70e6cc"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404122136/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0dfbae93ef000cb50e3384ec127bf0aad0eaf3f166b7288b2f82d68a07155313"
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

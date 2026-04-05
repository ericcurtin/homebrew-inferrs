class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260405154916"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405154916/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3dc98d7c9879a1e51c9d3ac1a93f5bb002e9dc64acb75ffbaedfd9f692997e68"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405154916/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "34be887665c7e2887b1abea0ca5dd18a7179b89f1a950826634d8fb611da8e0c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405154916/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "03268c1fbf5d53406f7156703a464630fbdc9e62fb4263d6c28636047e5d20d9"
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

class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409012618"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409012618/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "15ee3210352565c3db99ac4efda090c4e2e89081bdb952a4e8d307735d656ee0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409012618/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21fa3e514a29f51d955c6d5b11bfa648da79d043bcbb0dddfd2e180bd804ad2b"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409012618/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7325990fed08564c7c5b45710820734b9e36a2fa83f46ce662ea896cf220019c"
    end
  end

   def install
     bin.install "inferrs"

     # Install GPU backend plugins alongside the binary so the
     # inferrs binary can find them via dlopen at runtime.
     %w[
       libinferrs_backend_cuda.so
       libinferrs_backend_musa.so
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

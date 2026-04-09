class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409063313"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409063313/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "c4f5a73f70e5606fcbdb5d20ddda7ded8b7288cde225758be27bd7df8923afd7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409063313/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e034882c5482c8a3e2d6956bd87d3a4f4edc571dfbf4e988cac806bce84f2d17"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409063313/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7896520520c2f1ecab2ed3268ecfb6d8e48f2c80c317651e82321a627a78686c"
    end
  end

   def install
     bin.install "inferrs"

     # Install GPU/NPU backend plugins alongside the binary so the
     # inferrs binary can find them via dlopen at runtime.
     %w[
       libinferrs_backend_cann.so
       libinferrs_backend_cuda.so
       libinferrs_backend_hexagon.so
       libinferrs_backend_musa.so
       libinferrs_backend_openvino.so
       libinferrs_backend_openvino.dylib
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

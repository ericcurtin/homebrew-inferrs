class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413020336"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413020336/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "a95de074d5e75d317c5e4c18a667bc2d84cc4a56238e15ad27c76e18aa4342f9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413020336/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a8d2473ff4876d482944a0fff2b7867bd3b731b24d822f679780f0c2f732419a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413020336/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f7555f635a20cf993a4fddd3d97fc032b30150ee0b6ff32efd5d8cbab82f6621"
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

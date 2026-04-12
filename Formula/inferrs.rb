class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260412130214"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130214/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "658a92c1112ba941061f97d63a6dbda47501c3b6abc01e0b106776f17087a190"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130214/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a8a28b9bbe1a1abcbfcf45d8b50ee470593388ffb62ccc6fa1b6f4301962a89e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130214/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3fe8e3228ea111ec4ed1af105018996d8c50efb8618451e53fd46d6b1fef44bb"
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

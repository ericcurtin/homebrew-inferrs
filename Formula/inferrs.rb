class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413145756"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413145756/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "9864159d845b05acc39c5d838a6cc21f1357b7a0ad31caecc23e70bb78ad1057"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413145756/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "22ae8a32d0da5d976e3f28e8eb3009ad28f1346d7a9e206f15b50134c4bcd07c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413145756/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9de7f428df32c7cee91c89b4a8c0d6f0afe58054eae5cf0c4d4958cd0536c491"
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

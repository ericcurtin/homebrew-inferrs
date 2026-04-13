class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413173507"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413173507/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "8b8d1323a4367deba783ab53cc43bf617b18b290458f9e6ab99881f0139b7f82"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413173507/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f3d95968f70d19601e9fae721538e7657e48ab0de48ac8a1526dd3221065570"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413173507/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "27f11ce0ab1bb9bc17903758b9b6cf15a894c2403dc453dcdca21dc8bec15bfd"
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

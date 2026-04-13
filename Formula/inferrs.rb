class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413135005"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413135005/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "8aaff07964569d743577845e493e7f15cd1898d26453d9b6cca8aca0c8bffee1"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413135005/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c10fb4d896306f52649ecc7cddd0a330fdd207a072fbc4cdef01f3f462028ce3"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413135005/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3c2ca8bddf127437e079e2bb2242270a4c3b535338294ef2ecdf26478e2f4a6"
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

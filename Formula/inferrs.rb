class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260412140237"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412140237/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "fafc7a5ef789576057377665ff25d805b2dd48288001454f13f4629076581729"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412140237/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "54e4867bc42892f5a3ff515481091639e48e29ac23bf95def9424387323065d6"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412140237/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aaf684a7a24b36a5eb5d09f8c0671ec298d9eebd5a30f8de53a0645ae5612189"
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

class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411232731"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411232731/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "1e8d90a92a9250bebd4e747a65b7947586897f7c503f0493f2b7946d993eff83"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411232731/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d54bd0b80728ae21e6352399b21e188d6d3dd0982c1a15f9be03a95c0026a8a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411232731/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2ec314050d60ad9c6c1429621b8cd662f5b7907a81ae3724428a4d92612d5c5f"
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

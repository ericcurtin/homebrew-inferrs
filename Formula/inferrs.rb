class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260418124024"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418124024/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "a741fe2e0a474e4686bd0d0d25ee2c447abfe8c5c91b510d92561d1aaf764f99"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418124024/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0eb085a3a4c3d24c9cb50afba6224e2d282c2b2c1074d1593ec9c77a1006016"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418124024/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7532849f79cf1f3838653cdbc51ca24f638bf93126ff140499743b6023c1f00c"
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

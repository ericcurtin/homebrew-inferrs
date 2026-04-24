class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260424105406"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424105406/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "49f1ea6d97c80983fbdb975f3f2997589650a919c2d087c0c2f85ad7b9d9cafc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424105406/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8f1a78ccf6ece3eb7e3e2976c2e23c628699c62202ed477696423de2d292191"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424105406/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eaa26d513b001bebcb589ebb9595cbb436dc61fb1413316f8af61ebab60deb6a"
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

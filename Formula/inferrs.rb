class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260421101109"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421101109/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3ae75acc93d693b455325066d88593b896f0dd8cd4978e07e48b35cd4fd0a248"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421101109/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "022d82fdca832bd2e701d2234422ac18cf283f720ed5ec814e58c6eddb287bfb"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421101109/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72491ddd48c8bf692c1514bb44cc4f8238d265e5ea72ecdb43399600cdc8e831"
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

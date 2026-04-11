class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411152110"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411152110/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "b1725b40e38e73f72ea231ef956bfa3ddceec2f403be409555cb5446b9780e7b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411152110/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aee76b5477a2a64ca8f503780f61b46b313a5379a094f0b346400b1c4ca905d1"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411152110/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f8f19ecf789e1f3efbd510d44f34fee4d8dc9450e2a5cbcda57ab389f1cc5c45"
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

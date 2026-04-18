class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260418103338"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103338/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3fdbd14a59ab40b6eb49508a954240a5e767dcb65661a4afd2a3b9bf6b5a7ed3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103338/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3d270e537262df68c95374341dbf1536902fbb2b7646a6a3105bce75eb1e18a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103338/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "309f4ce56a43ed4178120977ebeebbf8c641961a912f9e609d142472c0e430f0"
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

class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413201932"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201932/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "317de15c054c4e68d23f5d3426c6e9b24505e4b4100c59fb29eb78b3f7ba15a7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201932/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cf5a94b3e8575d8ab2eab1624e969a396a92447caf6033c26181fa2231e8e56d"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201932/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9d9a4e91a4ffb0ab9ea13315486e55f3dd1c29eff3b9905e2ab160c3b90a0456"
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

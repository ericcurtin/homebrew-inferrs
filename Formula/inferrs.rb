class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413171054"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413171054/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "43aafd3d15ce2371b3d8a0699fab51943bf331070cdb79a437809cf9081b43cc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413171054/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fb0b28424cb5a1267416a0867ff30d76549b35da04203c157a10b1fe410b9ba1"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413171054/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f7b4edb0e2916aafe96dc3160325cf9807bba4f143d9aaea90d230500a26e69f"
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

class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413175349"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413175349/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "ce174f5e234c3853ba277eff6400d7fe1d6a404f84bab2cb1eee787f9b405f19"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413175349/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ef3a6229cf4714324ca309ea369daaf737879b8ed80a1880f23eae97760ba51a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413175349/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b6c1a8b216550fc265b610367ee6f0858fa991088351a09abef5c88045d1e321"
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

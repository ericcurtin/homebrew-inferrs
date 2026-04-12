class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260412235601"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412235601/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "52592c82b35f467edc5f408fb982094d7af840983ff62a364f8cd14a94e557d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412235601/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b16c15c84ea60bc013133957103ec060b0fe1ecdbb1ac6a8941244c98b48b516"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412235601/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9cfded699376ea06a1ad73879427f0c60c3f6dfde663423d9bd7e8d1fce0eab9"
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

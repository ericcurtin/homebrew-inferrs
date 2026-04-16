class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260416102056"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102056/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "76b0e8868cf22319e93f0fc487d57900cc3210b240b828f3654364d9d81c4f61"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102056/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b76b0b02f443459cc7400389d61fea2182424e2eddf82062f96fde9aad6fa15"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102056/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "abcceadc7ce4a0593afb504f7d7aff896cb9389ef7c4da6cee6cba9a8157b790"
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

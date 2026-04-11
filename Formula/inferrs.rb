class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411222643"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411222643/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "1f5698d6482271d7b1e92521131967cf34fb2b64d680ea8b2086b7322c3a2d48"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411222643/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "299905903b136dd98a60b193e1786947be72af2d495d8227913c19d15e3e9a8d"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411222643/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "312b7282e8b19bba6846516a6c2114d6c20f27a8f7bab81757a1e4266c8f760c"
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

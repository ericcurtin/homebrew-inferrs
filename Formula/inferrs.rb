class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411103641"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411103641/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "cea3ff94db4466f5edb449e4bec39cd5443e2a8dd07a6dab766a0f0eafcec024"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411103641/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "092859c9747874f8cd7027b6a220791238c3c16fab81fb3ada999305940aa167"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411103641/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a1ab4ee5f6a9b0bd0fbf6f62f6bdbd5742c1ef981d46ed77f37099166f0661b3"
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

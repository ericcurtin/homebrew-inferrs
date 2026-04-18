class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260418102648"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418102648/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "cc2824e4b29b7552adb372598a72842fd2e2449f5457f3a4fa31ff035e83f0ad"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418102648/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "28a3be5a90020c784ed382f0852dba9755bdd93d163ad3a521eb26cb137c82c4"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418102648/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a8d96552fc30cee0d5dbb147ca6777b20140181b0bfc359a037e76c216a1c53"
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

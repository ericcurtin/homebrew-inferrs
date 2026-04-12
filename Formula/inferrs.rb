class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260412130231"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130231/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "5ec452a30395deac341bf8a832c16d64f6f875ccc5df23fd17e4e20e93b692f8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130231/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6ff1a40a4e7981c63eed8e694181c8ed81566e9dea0ec086e55c1c48741b60bb"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260412130231/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05225a26bf5432a518b545739fdb83e6c9beb7efbd9e978021c2b5195cc53678"
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

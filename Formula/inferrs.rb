class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413210123"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413210123/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "85548a7408e9ea83a92c45b382191dc066ba4636257ac5289dcd83de8c86f3b6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413210123/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a38c35b9438a7a75f67b972df91a29631642c831ac4c0a363372415ec7cfdedd"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413210123/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "309ea8007b50b424e3e545584aa1892209bc4e5f9f9b4da2e5f57df650e95ff7"
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

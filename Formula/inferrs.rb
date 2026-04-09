class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409054918"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054918/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "0c90ac6d1a506d388aecca9f850b7c56adad812a3c5759b6665ef6d6736abe93"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054918/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "25275d1055e032c47e9330a672ddae64fb754bc6136dcedafbcece9f6dc924a3"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054918/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9559880ebde93bcc99c9d6ae5e63988fa2729faf5a9fcee80917d1d81136e4e1"
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

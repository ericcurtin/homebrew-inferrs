class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413185309"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413185309/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "0adc16cdb1139f6e00047d7f31ade1ce686934924551198ca565580398fd6dfc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413185309/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0d2cc5e44f9e717d54e69a034ff1697aea3377d3f8f99e76e7420f030c7474aa"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413185309/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "658abf19505ed4f5648c8484b4126dc6728879389aa97872e2e4e5c370be34a0"
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

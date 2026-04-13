class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413134802"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413134802/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "f58afba4a80a8d6f98f0bdbb195de6bcf32bff42e1551d8dcc717fe6a1544b39"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413134802/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dfc99e115b92d6e026fe5b660f7dbfc01976631386e7008a143b852c85546a0e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413134802/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c545f3dcbdeddd5107b53669bcf655d60c847fcfdf4e9454eb08d51e16677d3d"
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

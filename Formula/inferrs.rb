class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "b59abfae18d3ea96648b0554c216f53344549cee"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "74d014741b8c639dd52a8ea1dc6681c638990e83559411a465135d69d8a4300e"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bd4be18fb52904e8cc48a1b6fc5e24183529846141a7a43ca5f5e8b3bbe83d05"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11214e90d732698aacd5d589935fb2f294ba2204838e6e610a982bc2f698d7e6"
    end
  end

  def install
    bin.install "inferrs"

    # Install GPU backend plugins alongside the binary.
    # The inferrs binary probes these at runtime via dlopen — only the
    # plugins that match the host hardware are actually used.
    # Missing plugins are silently skipped (CPU fallback applies).
    %w[
      libinferrs_backend_cuda.so
      libinferrs_backend_rocm.so
      libinferrs_backend_vulkan.so
    ].each do |lib|
      (lib_path / "inferrs" / lib).install lib if File.exist?(lib)
    end
  end

  def post_install
    # Create a symlink so the binary can find sibling plugins in the
    # same directory (the binary searches its own dir first).
    # On Linux, also link into the standard search path.
    return unless OS.linux?

    plugin_dir = lib_path / "inferrs"
    bin_dir    = bin.realpath
    plugin_dir.children.select { |f| f.extname == ".so" }.each do |so|
      (bin_dir / so.basename).make_symlink(so) unless (bin_dir / so.basename).exist?
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "8b9ccfa78740f9b715801a411bb1ede0374c790b"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "b73cb76f450b3a69b35a2dad2526b171629ae7bcec14b6c313b2590ed7bfe50b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c030975ea275771a18fb528f3ec777c7e466c46a9582ac2fb88da797a7219e48"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b5f5a72c2eb7a495fcc4188f74080baa9f85df80b033b0b14de9c7329ad004ff"
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
    ].each do |plugin|
      (lib / "inferrs").install plugin if File.exist?(plugin)
    end
  end

  def post_install
    # Create a symlink so the binary can find sibling plugins in the
    # same directory (the binary searches its own dir first).
    # On Linux, also link into the standard search path.
    return unless OS.linux?

    plugin_dir = lib / "inferrs"
    bin_dir    = bin.realpath
    plugin_dir.children.select { |f| f.extname == ".so" }.each do |so|
      (bin_dir / so.basename).make_symlink(so) unless (bin_dir / so.basename).exist?
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end

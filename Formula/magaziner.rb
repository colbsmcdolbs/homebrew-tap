class Magaziner < Formula
  desc "CLI tool that downloads LRB and Harper's Magazine issues and generates EPUB files for e-readers"
  homepage "https://github.com/colbsmcdolbs/magaziner"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/colbsmcdolbs/magaziner/releases/download/v0.1.3/magaziner-aarch64-apple-darwin.tar.xz"
      sha256 "27c34b327eb0d5548559173c9dfe7f20091a74cd199c1e5ece610c72f7f73970"
    end
    if Hardware::CPU.intel?
      url "https://github.com/colbsmcdolbs/magaziner/releases/download/v0.1.3/magaziner-x86_64-apple-darwin.tar.xz"
      sha256 "590f3698e5c05ce3cb6bf93f902ec15e997a0338e278bcb442274a748515370a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/colbsmcdolbs/magaziner/releases/download/v0.1.3/magaziner-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e175a75bb657755214b847d87101cd7a012a5243ba02c9d73e85c977fea74ad8"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "magaziner" if OS.mac? && Hardware::CPU.arm?
    bin.install "magaziner" if OS.mac? && Hardware::CPU.intel?
    bin.install "magaziner" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

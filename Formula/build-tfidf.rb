class BuildTfidf < Formula
  include Language::Python::Virtualenv

  desc "High-quality semantic search for Markdown corpora"
  homepage "https://github.com/joshuascottpaul/build_tfidf"
  url "https://github.com/joshuascottpaul/build_tfidf/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "deddb1c7a2f68193ec87a619fdb894e853c52f8a7a111ae4e3166b886b9e0b61"
  license "MIT"

  depends_on "python@3.10"

  def install
    ENV["HOMEBREW_SKIP_RELOCATE"] = "1"
    venv = virtualenv_create(libexec, "python3.10")
    system libexec/"bin/python", "-m", "ensurepip"
    system libexec/"bin/python", "-m", "pip", "install", "--only-binary", ":all:", "--no-deps", "-r", buildpath/"requirements.txt"
    system libexec/"bin/python", "-m", "pip", "install", "--no-deps", "--no-build-isolation", buildpath
    bin.install_symlink libexec/"bin/tfidf-search"
  end

  test do
    system bin/"tfidf-search", "--help"
    (testpath/"corpus").mkpath
    (testpath/"corpus/alpha.md").write "# Alpha\n\nalpha note"
    system bin/"tfidf-search", "build", "--root", testpath/"corpus"
  end
end

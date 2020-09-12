class FileTypeChecker
  def initialize(path)
    @path = path
  end

  def libraly?
    gem? || ruby?
  end

  private

  def gem?
    @path.include? "/usr/local/bundle/gems"
  end

  def ruby?
    @path.include? "/usr/local/lib/ruby"
  end
end
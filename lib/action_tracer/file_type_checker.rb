module ActionTracer
  class FileTypeChecker
    def initialize
      @gem_paths = [ENV["GEM_HOME"], ENV["GEM_PATH"]&.split(":")].flatten.compact.uniq
    end

    def libraly?(path)
      gem?(path) || ruby?(path)
    end

    private

    def gem?(path)
      @gem_paths.one? { |gem_path| path.include? gem_path }
    end

    def ruby?(path)
      path.include? "/usr/local/lib/ruby"
    end
  end
end
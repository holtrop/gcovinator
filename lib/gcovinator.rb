require_relative "gcovinator/version"

module Gcovinator

  class << self

    def run(build_dir, source_dirs, files, output_dir)
      source_dirs = ["."] if source_dirs.empty?
      files = Dir["#{build_dir}/**/*.gcda"] if files.empty?
    end

  end

end

require_relative "gcovinator/version"
require "tmpdir"

module Gcovinator

  class << self

    def run(build_dir, source_dirs, files, output_dir)
      build_dir = File.expand_path(build_dir)
      source_dirs = ["."] if source_dirs.empty?
      source_dirs = source_dirs.map do |s|
        File.expand_path(s)
      end
      files = Dir["#{build_dir}/**/*.gcda"] if files.empty?
      files = files.map do |f|
        File.expand_path(f)
      end
      output_dir = File.expand_path(output_dir)
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          files.each do |f|
            IO.popen(["gcov", "-bmi", f]) do |io|
              io.read
            end
          end
        end
      end
    end

  end

end

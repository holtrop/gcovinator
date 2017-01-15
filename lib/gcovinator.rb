require_relative "gcovinator/file_coverage"
require_relative "gcovinator/file_report"
require_relative "gcovinator/gcov_parser"
require_relative "gcovinator/version"
require "fileutils"
require "open3"
require "pathname"
require "tmpdir"

module Gcovinator

  class << self

    def run(build_dir, source_dirs, files, output_dir)
      build_dir = Pathname.new(File.expand_path(build_dir)).cleanpath.to_s
      source_dirs = ["."] if source_dirs.empty?
      source_dirs = source_dirs.map do |s|
        Pathname.new(File.expand_path(s)).cleanpath.to_s
      end
      files = Dir["#{build_dir}/**/*.gcda"] if files.empty?
      files = files.map do |f|
        Pathname.new(File.expand_path(f)).cleanpath.to_s
      end
      output_dir = Pathname.new(File.expand_path(output_dir)).cleanpath.to_s
      file_coverages = {}
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          files.each do |f|
            stdout, stderr, status = Open3.capture3("gcov", "-bc", f)
            gcov_files = Dir["*.gcov"]
            gcov_files.each do |gcov_file|
              GcovParser.parse(gcov_file, file_coverages, build_dir, source_dirs)
              File.unlink(gcov_file)
            end
          end
        end
      end
      FileUtils.mkdir_p(output_dir)
      file_reports = file_coverages.each_with_index.map do |(source_file_name, file_coverage), i|
        FileReport.new(source_file_name, file_coverage, source_dirs, output_dir, sprintf("s%04d.html", i))
      end
    end

  end

end

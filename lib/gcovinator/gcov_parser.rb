module Gcovinator
  module GcovParser
    class << self

      def parse(gcov_file, file_coverages, build_dir, source_dirs)
        gcov_file = File.read(gcov_file)
        file_coverage = nil
        gcov_file.each_line do |line|
          if line =~ /^\s+\S*:\s*\d*:Source:(.*)$/
            filename = $1
            unless Pathname.new(filename).absolute?
              filename = Pathname.new(File.join(build_dir, filename)).cleanpath.to_s
            end
            filename = filename.gsub("\\", "/")
            unless source_dirs.any? {|s| filename.start_with?("#{s}/")}
              return
            end
            file_coverages[filename] ||= FileCoverage.new
            file_coverage = file_coverages[filename]
            next
          end
          next unless file_coverage
        end
      end

    end
  end
end

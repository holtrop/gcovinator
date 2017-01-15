module Gcovinator
  module GcovParser
    class << self

      def parse(gcov_file, file_coverages, build_dir, source_dirs)
        gcov_file = File.read(gcov_file)
        file_coverage = nil
        current_line_number = nil
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
          if line =~ /^\s*(\S+):\s*(\d+):/
            line_coverage, current_line_number = $1, $2.to_i
            if (line_coverage =~ /^#+$/) or
              (line_coverage =~ /^\$+$/) or
              (line_coverage =~ /^=+$/)
              file_coverage.log_line_count(current_line_number, 0)
            elsif line_coverage =~ /^\d+$/
              file_coverage.log_line_count(current_line_number, line_coverage.to_i)
            end
            next
          end
          if line =~ /^branch\s+(\d+)\s+(.*)$/
            branch_id, taken_extra = $1.to_i, $2
            branch_info = nil
            if taken_extra =~ /never.executed/
              taken_count = 0
            elsif taken_extra =~ /taken\s+(\d+)(?:.*\((.*)\))?/
              taken_count = $1.to_i
              branch_info = $2
            end
            file_coverage.log_branch(current_line_number, branch_id, taken_count, branch_info)
          end
        end
      end

    end
  end
end

module Gcovinator
  class FileReport

    def initialize(source_file_name, file_coverage, source_dirs, output_dir, report_file_name)
      @source_file_name = clean_source_file_name(source_file_name, source_dirs)
      @report_file_name = report_file_name
      @total_lines = 0
      @covered_lines = 0
      @total_branches = 0
      @covered_branches = 0
      run(source_file_name, File.join(output_dir, report_file_name), file_coverage)
    end

    private

    def clean_source_file_name(source_file_name, source_dirs)
      source_dirs.each do |source_dir|
        prefix_test = "#{source_dir}/"
        if source_file_name.start_with?(prefix_test)
          return source_file_name[prefix_test.size, source_file_name.size]
        end
      end
      source_file_name
    end

    def run(source_file_name, output_file_name, file_coverage)
      analyze(file_coverage)
      require "cgi"
      require "erb"
      source_file = read_source_file(source_file_name)
      source_file_lines = source_file.lines.to_a
      file_report_template = File.read(File.join(File.dirname(__FILE__), "../../assets/file_report.html.erb"))
      erb = ERB.new(file_report_template, nil, "<>")
      report = erb.result(binding.clone)
      File.open(output_file_name, "w") do |fh|
        fh.write(report)
      end
    end

    def analyze(file_coverage)
      file_coverage.line_counts.each do |line_number, count|
        @total_lines += 1
        @covered_lines += 1 if count > 0
      end
      file_coverage.branches.each do |line_number, branches|
        branches.each do |branch_id, branch_coverage|
          @total_branches += 1
          @covered_branches += 1 if branch_coverage[:taken_count] > 0
        end
      end
    end

    def read_source_file(source_file_name)
      begin
        File.read(source_file_name)
      rescue
        %[<Could not open #{source_file_name}>]
      end
    end

  end
end

module Gcovinator
  class IndexReport

    def initialize(output_dir, file_reports)
      @total_lines = 0
      @covered_lines = 0
      @total_branches = 0
      @covered_branches = 0
      run(File.join(output_dir, "index.html"), file_reports)
    end

    private

    def run(output_file_name, file_reports)
      analyze(file_reports)
      require "cgi"
      require "erb"
      index_report_template = File.read(File.join(File.dirname(__FILE__), "../../assets/index_report.html.erb"))
      erb = ERB.new(index_report_template, nil, "<>")
      report = erb.result(binding.clone)
      File.open(output_file_name, "w") do |fh|
        fh.write(report)
      end
    end

    def analyze(file_reports)
      file_reports.each do |file_report|
        @total_lines += file_report.total_lines
        @covered_lines += file_report.covered_lines
        @total_branches += file_report.total_branches
        @covered_branches += file_report.covered_branches
      end
    end

  end
end

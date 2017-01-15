module Gcovinator
  class FileReport

    def initialize(source_file_name, file_coverage, source_dirs, output_dir, report_file_name)
      @source_file_name = clean_source_file_name(source_file_name, source_dirs)
      @report_file_name = report_file_name
      @total_lines = 0
      @covered_lines = 0
      @total_branches = 0
      @covered_branches = 0
      run(source_file_name, File.join(output_dir, report_file_name))
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

    def run(source_file_name, output_file_name)
      require "erb"
      source_file = read_source_file(source_file_name)
      source_file_lines = source_file.lines.to_a
      file_report_template = File.read(File.join(File.dirname(__FILE__), "../../assets/file_report.html.erb"))
      erb = ERB.new(file_report_template, nil, "<>")
      report = erb.run(binding.clone)
      File.open(output_file_name, "w") do |fh|
        fh.write(report)
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
module Gcovinator
  class FileCoverage

    def initialize
      @line_counts = {}
      @branches = {}
    end

    def log_line_count(line_number, count)
      @line_counts[line_number] ||= 0
      @line_counts[line_number] += count
    end

    def get_line_count(line_number)
      @line_counts[line_number]
    end

    def log_branch(line_number, branch_id, taken_count, branch_info)
      @branches[line_number] ||= {}
      @branches[line_number][branch_id] ||= {
        taken_count: 0,
        branch_info: nil,
      }
      @branches[line_number][branch_id][:taken_count] += taken_count
      @branches[line_number][branch_id][:branch_info] = branch_info
    end

    def get_branch(line_number)
      @branches[line_number]
    end

  end
end

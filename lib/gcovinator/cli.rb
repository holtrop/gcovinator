require "gcovinator"
require "optparse"

module Gcovinator
  module Cli

    class << self

      def run(argv)
        argv = argv.dup
        build_dir = "."
        source_dirs = []
        output_dir = "coverage"

        OptionParser.new do |opts|

          opts.banner = "Usage: #{$0} [options] [FILES]"

          opts.separator ""
          opts.separator "Pass paths to .gcda files as FILES."
          opts.separator "If no FILES are specified, gcovinator looks for all .gcda files recursively under the build directory."
          opts.separator ""
          opts.separator "Options:"

          opts.on("-b BUILDDIR", "--build-dir BUILDDIR", "Specify the build directory. Source file paths in object/gcov files will be relative to this directory. Defaults to '.' if not specified.") do |b|
            build_dir = b
          end

          opts.on_tail("-h", "--help", "Show this help.") do
            puts opts
            exit 0
          end

          opts.on("-o OUTPUTDIR", "--output-dir OUTPUTDIR", "Specify output directory. HTML reports will be written to this directory. Defaults to 'coverage' if not specified.") do |o|
            output_dir = o
          end

          opts.on("-s SRCDIR", "--source-dir SRCDIR", "Specify a source directory. Reports will only be generated for sources under a specified source directory. Multiple source directories may be specified. Defaults to '.' if not specified.") do |s|
            source_dirs << s
          end

          opts.on_tail("--version", "Show version") do
            puts "gcovinator, version #{Gcovinator::VERSION}"
            exit 0
          end

        end.parse!(argv)

        Gcovinator.run(build_dir, source_dirs, argv)
      end

    end

  end
end

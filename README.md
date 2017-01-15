# Gcovinator

gcovinator is a command-line tool that can generate HTML reports showing the
line and branch coverage information for a source file. It is implemented as
a Ruby gem and requires Ruby to be installed to execute.

## Installation

With root access or something like rvm:

    $ gem install gcovinator

Or as an unprivileged user without something like rvm:

    $ gem install --user gcovinator

(in this case make sure the path to /bin under your ~/.gem directory is in your $PATH)

## Usage

    Usage: gcovinator [options] [FILES]

    Pass paths to .gcda files as FILES.
    If no FILES are specified, gcovinator looks for all .gcda files recursively under the build directory.

    Options:
        -b, --build-dir BUILDDIR         Specify the build directory. Source file paths in object/gcov files will be relative to this directory. Defaults to '.' if not specified.
        -o, --output-dir OUTPUTDIR       Specify output directory. HTML reports will be written to this directory. Defaults to 'coverage' if not specified.
        -p, --prefix PREFIX              Prefix path to strip from source file paths. Defaults to '.' if not specified.
        -s, --source-dir SRCDIR          Specify a source directory. Reports will only be generated for sources under a specified source directory. Multiple source directories may be specified. Defaults to '.' if not specified.
        -h, --help                       Show this help.
            --version                    Show version

### Example

If you store your source code under `src` and build from the `build`
directory, then execute:

    $ gcovinator -b build -s src

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/holtrop/gcovinator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

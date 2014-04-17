#--
###############################################################################
#                                                                             #
# cyclops -- A command-line option parser                                     #
#                                                                             #
# Copyright (C) 2014 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# cyclops is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# cyclops is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with cyclops. If not, see <http://www.gnu.org/licenses/>.             #
#                                                                             #
###############################################################################
#++

require 'safe_yaml/load'
require 'optparse'
require 'highline'
require 'zlib'

class Cyclops

  class << self

    def usage(prog)
      "Usage: #{prog} [-h|--help] [options]"
    end

    def version
      parent_const_get(:VERSION)
    end

    def defaults
      {}
    end

    def execute(*args)
      new.execute(*args)
    end

    private

    def parent_const_get(const, range = 0...-1)
      name.split('::').inject([Object]) { |memo, name|
        memo << memo.last.const_get(name)
      }.reverse[range].each { |mod|
        return mod.const_get(const) if mod.const_defined?(const, false)
      }

      raise NameError, "uninitialized constant #{self}::#{const}"
    end

  end

  attr_reader :options, :config, :defaults
  attr_reader :stdin, :stdout, :stderr

  attr_accessor :prog

  def initialize(defaults = nil, *args)
    @defaults, @prog = defaults || self.class.defaults, $0

    init(*args)

    # prevent backtrace on ^C
    trap(:INT) { exit 130 }
  end

  def progname
    File.basename(prog)
  end

  def usage
    self.class.usage(prog)
  end

  def version
    self.class.version
  end

  def execute(arguments = ARGV, *inouterr)
    reset(*inouterr)
    parse_options(arguments)
    run(arguments)
  rescue => err
    raise if $VERBOSE
    abort "#{err.backtrace.first}: #{err} (#{err.class})"
  ensure
    options.each_value { |value|
      value.close if value.is_a?(Zlib::GzipWriter)
    }
  end

  def run(arguments)
    raise NotImplementedError, 'must be implemented by subclass'
  end

  def reset(stdin = STDIN, stdout = STDOUT, stderr = STDERR)
    @stdin, @stdout, @stderr = stdin, stdout, stderr
    @options, @config = {}, {}
  end

  private

  def init(*args)
    reset
  end

  def highline
    @highline ||= HighLine.new(stdin, stdout)
  end

  def ask(question, echo = true)
    highline.ask(question) { |q|
      yield q if block_given?
      q.echo = echo
    }
  end

  def askpass(question, &block)
    ask(question, false, &block)
  end

  def agree(question, character = nil, &block)
    highline.agree(question, character, &block)
  end

  def puts(*msg)
    stdout.puts(*msg)
  end

  def warn(*msg)
    stderr.puts(*msg)
  end

  def quit(msg = nil, include_usage = msg != false)
    out = []

    out << "#{progname}: #{msg}" if msg
    out << usage if include_usage

    abort out.any? && out.join("\n\n")
  end

  def abort(msg = nil, status = 1)
    warn(msg) if msg
    exit(status)
  end

  def shut(msg = nil, status = 0)
    puts(msg) if msg
    exit(status)
  end

  def exit(status = 0)
    Kernel.exit(status)
  end

  def open_file_or_std(file, write = false)
    if file == '-'
      write ? stdout : stdin
    else
      gz = file =~ /\.gz\z/i

      if write
        gz ? Zlib::GzipWriter.open(file) : File.open(file, 'w')
      else
        quit "No such file: #{file}" unless File.readable?(file)
        (gz ? Zlib::GzipReader : File).open(file)
      end
    end
  end

  def load_config(file = options[:config] || default = defaults[:config])
    return unless file

    if File.readable?(file)
      @config = SafeYAML.load_file(file, :deserialize_symbols => true)
    else
      quit "No such file: #{file}" unless default
    end
  end

  def merge_config(args = [config, defaults])
    args.each { |hash| hash && hash.each { |key, value|
      options[key] = value unless options.key?(key)
    } }
  end

  def parse_options(arguments)
    option_parser.parse!(arguments)

    load_config
    merge_config
  end

  def option_parser
    OptionParser.new { |opts|
      opts.extend(OptionParserExtension).cli = self

      opts.banner = usage

      pre_opts(opts)

      opts.separator
      opts.separator 'Options:'

      config_opts(opts)
      opts(opts)

      opts.separator
      opts.separator 'Generic options:'

      generic_opts(opts)
      post_opts(opts)
    }
  end

  def pre_opts(opts)
  end

  def config_opts(opts, desc = 'Path to config file (YAML)')
    if config = defaults.fetch(:config) { return }
      desc += ' [Default: %s (%s)]' % [config,
        File.readable?(config) ? 'present' : 'currently not present']
    end

    opts.option(:config__FILE, desc)

    opts.separator
  end

  def opts(opts)
  end

  def verbose_opts(opts)
    verbose, debug = defaults.key?(:verbose), defaults.key?(:debug)

    opts.switch(:verbose, 'Print verbose output') if verbose

    msg = "; #{debug_message}" if respond_to?(:debug_message, true)
    opts.switch(:debug, :D, "Print debug output#{msg}") if debug

    opts.separator if verbose || debug
  end

  def generic_opts(opts)
    verbose_opts(opts)

    opts.option(:help, 'Print this help message and exit') {
      shut opts
    }

    opts.option('version', 'Print program version and exit') {
      shut "#{progname} v#{version}"
    }
  end

  def post_opts(opts)
  end

end

require_relative 'cyclops/version'
require_relative 'cyclops/option_parser_extension'
require File.expand_path(%q{../lib/cyclops/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{cyclops},
      version:      Cyclops::VERSION,
      summary:      %q{A command-line option parser based on optparse.},
      description:  %q{Provides a convenient interface around optparse.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: %w[highline safe_yaml],

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

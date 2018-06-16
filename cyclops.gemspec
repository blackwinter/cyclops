# -*- encoding: utf-8 -*-
# stub: cyclops 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cyclops".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2018-06-16"
  s.description = "Provides a convenient interface around optparse.".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "lib/cyclops.rb".freeze, "lib/cyclops/option_parser_extension.rb".freeze, "lib/cyclops/version.rb".freeze]
  s.homepage = "http://github.com/blackwinter/cyclops".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\ncyclops-0.3.0 [2018-06-16]:\n\n* <b>Dropped support for Ruby 2.0.</b>\n* Dropped +safe_yaml+ dependency in favour of standard library.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "cyclops Application documentation (v0.3.0)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "A command-line option parser based on optparse.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>.freeze, [">= 0"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.7", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<highline>.freeze, [">= 0"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.7", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>.freeze, [">= 0"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.7", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end

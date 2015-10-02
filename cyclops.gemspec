# -*- encoding: utf-8 -*-
# stub: cyclops 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cyclops"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2015-10-02"
  s.description = "Provides a convenient interface around optparse."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "lib/cyclops.rb", "lib/cyclops/option_parser_extension.rb", "lib/cyclops/version.rb"]
  s.homepage = "http://github.com/blackwinter/cyclops"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\ncyclops-0.2.0 [2015-10-02]:\n\n* Extracted Cyclops#open_file and Cyclops#open_std from\n  Cyclops#open_file_or_std so they can be overwritten in subclasses.\n\n"
  s.rdoc_options = ["--title", "cyclops Application documentation (v0.2.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.8"
  s.summary = "A command-line option parser based on optparse."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_runtime_dependency(%q<safe_yaml>, [">= 0"])
      s.add_development_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<safe_yaml>, [">= 0"])
      s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<safe_yaml>, [">= 0"])
    s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{isoelectric_point}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['GeorgeG', "pascalbetz"]
  s.date = %q{2010-10-07}
  s.description = %q{Calculate the Isoelectric point}
  s.email = %q{info@simplificator.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
     "LICENSE",
     "README.rdoc",
     "lib/isoelectric_point.rb",
     "lib/isoelectric_point/pka_data.rb",
     "lib/isoelectric_point/extensions.rb",
     "lib/isoelectric_point/aa.rb",
  ]
  s.homepage = %q{http://github.com/GeorgeG/isoelectric_point_4_R}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Calculate isoelectric point.}
  s.test_files = [
    "test/aa_test.rb",
    "test/extensions_test.rb",
    "test/test_helper.rb"

  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
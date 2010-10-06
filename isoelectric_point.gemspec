# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{isoelectric_point}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['GeorgeR', "pascalbetz"]
  s.date = %q{2010-10-05}
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
     "lib/isoelectric_point/data.rb",
     "lib/isoelectric_point/extensions.rb",
     "lib/isoelectric_point/sequence.rb",
  ]
  s.homepage = %q{http://github.com/simplificator/isoelectric_point}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Calculate isoelectric point. Based on code frmo GeorgeR. We just took it and made a gem of it.}
  s.test_files = [
    "test/sequence_test.rb",
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


# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{promise}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lourens Naud\303\251 (methodmissing)", "James Tucker (raggi)"]
  s.date = %q{2010-03-03}
  s.description = %q{Lightweight Ruby MRI promise extension}
  s.email = %q{lourens@methodmissing.com}
  s.extensions = ["ext/promise/extconf.rb"]
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "Rakefile", "promise.gemspec", "bench/promise.rb", "ext/promise/extconf.rb", "ext/promise/promise.c", "ext/promise/promise.h", "test/test_promise.rb"]
  s.homepage = %q{http://github.com/methodmissing/promise}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Native MRI promise}
  s.test_files = ["test/test_promise.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
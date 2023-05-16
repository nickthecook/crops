# frozen_string_literal: true

Gem::Specification.new do |s|
	s.name = 'ops_team'
	s.version = '2.0.4.rc2'
	s.authors = [
		'nickthecook@gmail.com'
	]
	s.summary = 'ops_team handles basic automation for your project, driven by self-documenting YAML config'
	s.homepage = 'https://github.com/nickthecook/crops'
	s.files = Dir[
		'bin/ops',
		'build/darwin_x86_64/ops',
		'build/linux_x86_64/ops',
		'build/darwin_arm64/ops'
	]
	s.executables = ['ops']
	s.add_runtime_dependency 'ejson', '~> 1.2', '>= 1.2.1'
	s.license = 'GPL-3.0-only'
	s.required_ruby_version = '> 2.5'
end

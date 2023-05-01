# frozen_string_literal: true

Gem::Specification.new do |s|
	s.name = 'ops_team'
	s.version = '2.0.0.rc3'
	s.authors = [
		'nickthecook@gmail.com'
	]
	s.summary = 'ops_team handles basic automation for your project, driven by self-documenting YAML config'
	s.homepage = 'https://github.com/nickthecook/crops'
	s.files = Dir[
		'bin/ops',
		'build/darwin_amd64/ops',
		'build/linux_amd64/ops',
		'build/darwin_arm64/ops'
	]
	s.executables = ['ops']
	s.license = 'GPL-3.0-only'
end

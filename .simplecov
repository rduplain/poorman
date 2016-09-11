require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
])

SimpleCov.add_group 'poorman', 'poorman$'
SimpleCov.add_filter '^((?!poorman$).)*$' # Filter everything but poorman file.

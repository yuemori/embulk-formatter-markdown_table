
Gem::Specification.new do |spec|
  spec.name          = "embulk-formatter-markdown_table"
  spec.version       = "0.1.0"
  spec.authors       = ["YOUR_NAME"]
  spec.summary       = "Markdown Table formatter plugin for Embulk"
  spec.description   = "Formats Markdown Table files for other file output plugins."
  spec.email         = ["YOUR_NAME"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/YOUR_NAME/embulk-formatter-markdown_table"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'csvtomd', ['>= 1.0.1']
  spec.add_development_dependency 'embulk', ['>= 0.8.3']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end

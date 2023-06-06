# frozen_string_literal: true

require "json"

result = {}

dirs = Dir.glob('app/**')
  .delete_if { |dir | dir.start_with?('app/assets/') }
  .delete_if { |dir | dir.start_with?('gems/') }
  .delete_if { |dir | dir.start_with?('sorbet/') }
  .map { |dir| dir.split("/")[1..-2] }

%w[ts js].each do |x|
  result["*.test.#{x}"] = {
    alternate: %w[ts js].map do |y|
      [
        "{}.#{y}",
        "{dirname|dirname}{basename}.#{y}",
      ]
    end.flatten,
  }
  result["*.#{x}"] = {
    alternate: %w[ts js].map do |y|
      [
        "{}.test.#{y}",
        "{dirname}/__tests__/{basename}.test.#{y}",
      ]
    end.flatten,
  }
end

template = [
  "# typed: true",
  "# frozen_string_literal: true",
  "",
  "class {camelcase|capitalize|colons}",
  "end",
]

test_template = [
  "# typed: true",
  "# frozen_string_literal: true",
  "",
  "require \"rails_helper\"",
  "",
  "RSpec.describe {camelcase|capitalize|colons}",
  "  before(:each) do",
  "  end",
  "",
  "  let(:subject) { described_class.new }",
  "end",
]

dirs.each do |dir|
  dir = dir.join("/")

  result["app/#{dir}*.rb"] = {
    "alternate": [
      "spec/#{dir}/{}_spec.rb",
    ],
    "type": "source",
    "template": template,
  }
  result["spec/#{dir}/*_spec.rb"] = {
    "alternate": [
      "app/#{dir}/{}.rb",
    ],
    "type": "test",
    "template": test_template,
  }
end

# puts result.to_json
puts JSON.pretty_generate(result)

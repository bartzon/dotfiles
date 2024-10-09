require 'rake'
require 'erb'

FILES = [
  'asdfrc',
  'bat',
  'bin',
  'config',
  'fzf.zsh',
  'gitconfig',
  'gitignore',
  'hammerspoon',
  'tmux.conf',
  'tuple',
  'vale.ini',
  'zsh',
  'zshrc'
]

desc "install the dot files into user's home directory"
task :install do
  FILES.each do |file|
    next if %w[Rakefile README LICENSE].include? file

    replace_file(file)
  end
end

def replace_file(file)
  system %(rm -rf "$HOME/.#{file.sub('.erb', '')}")
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %(ln -s "$PWD/#{file}" "$HOME/.#{file}")
  end
end

def todo(component, message)
  say "\033[36mTODO\033[0m check TODO file when configuring #{component}"
  create_file 'TODO', '' unless File.exist?('TODO')
  append_file 'TODO', "[ ] #{message} (#{component})\n"
end

def database_username
  return @database_username if defined?(@database_username)
  @database_username = ask("Enter dev DB username (#{ENV['USER']}):")
  @database_username = ENV['USER'] if @database_username.blank?
end

def use_sorcery?
  return @use_sorcery if defined?(@use_sorcery)
  @use_sorcery = yes?('Generate barebones authentication using Sorcery?')
end

def require_ssl?
  return @require_ssl if defined?(@require_ssl)
  @require_ssl = yes?('Will this application require SSL in production?')
end

def prepend_to_rspec_config(text)
  inject_into_file 'spec/spec_helper.rb', text, after: "RSpec.configure do |config|\n"
end
alias rspec_config prepend_to_rspec_config

def cat(filename)
  File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', filename)))
end

def erb(filename)
  ERB.new(cat(filename)).result(binding)
end

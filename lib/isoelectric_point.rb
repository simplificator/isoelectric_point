['extensions', 'sequence'].each do |name|
  require File.join(File.dirname(__FILE__), 'isoelectric_point', name)
end
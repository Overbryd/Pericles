require 'spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
require 'pericles'

def tmpdir
  tmpdir = File.join(File.dirname(__FILE__), '../tmp')
  FileUtils.mkdir(tmpdir) unless File.directory?(tmpdir)
  tmpdir
end

Spec::Runner.configure do |config|

end
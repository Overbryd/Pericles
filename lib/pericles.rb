class Pericles
  class << self
    def configure(configuration)
      @config ||= OpenStruct.new(configuration)
    end
    
    def config
      @config
    end
    
    def pwdfile
      FileUtils.touch(config.pwdfile) unless File.exist?(config.pwdfile)
      config.pwdfile
    end
    
    def user_data_dir(name = '')
      File.join(config.user_data_dir, name)
    end
    
    def user_config(name)
      File.join(config.user_config_dir, name)
    end
    
    def names
      File.read(pwdfile).scan(/^(.*):/).flatten
    end
  
    def add(name, password)
      htpasswd "-b #{pwdfile} #{name} #{password}"
      FileUtils.mkdir_p user_data_dir(name)
      FileUtils.touch user_config(name)
    end
    
    def destroy(name)
      htpasswd "-D #{pwdfile} #{name}"
      FileUtils.rm_r user_data_dir(name)
      File.delete user_config(name)
    end
    
    private
    
    def htpasswd(cmd)
      output = `htpasswd #{cmd} 2>&1`
      raise "htpasswd: #{output}" unless $?.success?
    end
  end
end
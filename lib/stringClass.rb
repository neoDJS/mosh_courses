class String
    def validate regex
      !self[regex].nil?
    end
    
    def new_capitalize
      self.split(" ").collect(&:capitalize).join(" ")
    end

    # String.include AllOfMyColors
    def bg_red; "\e[41m#{self}\e[0m" end
    def bg_blue; "\e[44m#{self}\e[0m" end
    def blue; "\e[34m#{self}\e[0m" end
    def white; "\e[38m#{self}\e[0m" end
    def green; "\e[32m#{self}\e[0m" end 
    def red; "\e[31m#{self}\e[0m" end
  end
  
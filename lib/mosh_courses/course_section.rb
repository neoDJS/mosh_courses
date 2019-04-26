class MoshCourses::Section
    attr_accessor :url, :title
    @@all_s = []
    def initialize(section_ash)
        author_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_s << self
    end

    def self.create_from_collection(section_arr)
        section_arr.map{|section_ash|
            self.new(section_ash)
        }
    end

    def self.all
        @@all_s
    end
end
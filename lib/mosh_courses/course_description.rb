class MoshCourses::Description
    attr_accessor :sections
    @@all_d = []
    def initialize(author_ash)
        author_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_d << self
    end

    def self.all
        @@all_d
    end

    def sections=(section_arr)
        @sections = MoshCourses::Section.create_from_collection(section_arr)
    end
end
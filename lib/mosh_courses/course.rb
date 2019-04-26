class MoshCourses::Course
    attr_accessor :url, :title, :subtitle, :price, :img_url, :author, :description
    @@all_c = []

    def initialize(course_ash)
        course_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_c << self
    end

    def self.create_from_collection(course_arr)
        course_arr.map{|course_ash|
            self.new(course_ash)
        }
    end

    def self.all
        @@all_c
    end

    def self.getCourse(index)
        self.all[index] if !self.all.empty?
    end

    def author=(author_ash)
        @author = MoshCourses::Author.new(author_ash)
    end

    def description=(coursePart_arr)
        @description = ZeroCourses::Description.create_from_collection(coursePart_arr)
    end

    def add_attribute(attribute_hash)
        attribute_hash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
    end 

    def to_s
        "#{self.title} #{self.subtitle} #{self.price}"
    end

    def toPrint(val = -1)
        puts "#{val+1} - #{self.to_s}"
        puts "------------------------------------------------------------------------------------"
    end

    def show
    end

    def showSection
    end
end
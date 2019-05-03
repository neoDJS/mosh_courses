class MoshCourses::Course
    attr_accessor :url, :title, :subtitle, :price, :img_url, :author, :description
    @@all_c = []
    @@all_s_c = []

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
        return @@all_s_c unless @@all_s_c.empty?
        @@all_c
    end

    def self.getCourse(index)
        self.all[index] unless self.all.empty?
    end

    def self.search(matching)
        @@all_s_c = self.all.select{|c| c.title =~ /[a-zA-Z\s]*(#{matching})[a-zA-Z\s]*/}
    end

    def self.clear_search
        @@all_s_c.clear
    end

    def author=(author_ash)
        @author = MoshCourses::Author.new(author_ash)
    end

    def description=(courseSect_arr)
        @description = MoshCourses::Description.create_from_collection(courseSect_arr)
    end

    def add_attribute(attribute_hash)
        attribute_hash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
    end 

    def to_s
        "#{self.title.blue} - #{self.price}"
    end

    def toPrint(val = -1)
        puts "#{val+1} - #{self.to_s}"
        puts "------------------------------------------------------------------------------------"
    end

    def show
        puts "#{self.title.blue} - #{self.price.red}"
        puts "#{self.url}"
        puts "#{self.subtitle.bg_blue}"
        puts "\t\t\t\t\t#{self.author.name.red}"
    end

    def showSection
        puts "#{self.title.blue} - #{self.author.name.red}"
        puts "#{self.url}"
        self.description.bePrinted
    end
end
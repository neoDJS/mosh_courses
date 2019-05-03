class MoshCourses::Section
    attr_accessor :items, :title
    @@all_s = []
    def initialize(section_ash)
        section_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_s << self
    end

    def items=(item_arr)
        @items = MoshCourses::Item.create_from_collection(item_arr)
    end

    def self.create_from_collection(section_arr)
        section_arr.map{|section_ash|
            self.new(section_ash)
        }
    end

    def self.all
        @@all_s
    end

    def printed
        puts "#{self.title.bg_green}"
        self.items.each do |item|
            puts "\t#{item.label.green}"
        end
    end
end
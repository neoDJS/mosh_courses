class MoshCourses::Item
    attr_accessor :url, :label
    @@all_i = []
    def initialize(item_ash)
        author_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_i << self
    end

    def self.create_from_collection(item_arr)
        item_arr.map{|item_ash|
            self.new(item_ash)
        }
    end

    def self.all
        @@all_i
    end
end
class MoshCourses::Author
    attr_accessor :profile_url, :name
    @@all_a = []
    def initialize(author_ash)
        author_ash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all_a << self
    end

    def self.all
        @@all_a
    end
end
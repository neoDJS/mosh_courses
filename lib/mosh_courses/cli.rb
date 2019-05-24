class MoshCourses::CLI
    attr_accessor :openedCourse, :deepState, :currState
    def initialize
        self.currState = 'list'
        self.deepState = 1
        self.openedCourse = nil
    end

    def call
        # enter your code here
        # puts "hello you"
        # puts MoshCourses::MoshScraper.new.getCourses.inspect
        # puts MoshCourses::MoshScraper.new.getCourseDescription("/courses/293204").inspect
        running
    end



    Menu ={ "list" => {label: "List all Mosh courses",
                deep_state: 1,
                bloc: define_method("list_courses"){
                                                        done = false
                                                        MoshCourses::Course.clear_search
                                                        if !MoshCourses::Course.all.empty?
                                                            self.currState = 'list'
                                                            puts "Here is the Courses list on Mosh: \n\n" 
                                                            MoshCourses::Course.all.each_with_index{|c, i| c.toPrint(i) }
                                                            done = true
                                                            self.deepState += 1
                                                        else
                                                            puts "There is no course availaible on Mosh. List is Empty"
                                                        end
                                                        self.openedCourse = nil
                                                        return done
                                                    }
                },
        "search" => {label: "Search a course by matching name",
                deep_state: 1,
                bloc: define_method("find_course"){ 
                                                    done = false
                                                    puts "\n\t\tenter your searching option : "
                                                    search = getCourseName
                                                    if !MoshCourses::Course.all.empty?
                                                        self.currState = 'search'
                                                        puts "Here is the matching search list Courses on Mosh: \n\n" 
                                                        MoshCourses::Course.search(search).each_with_index{|c, i| c.toPrint(i) }
                                                        done = true
                                                        self.deepState += 1
                                                    else
                                                        puts "There is no course availaible on Mosh. List is Empty"
                                                    end
                                                    self.openedCourse = nil
                                                    return done
                                                }
                },
        "choose" => {label: "Choose a course",
                deep_state: 2,
                bloc: define_method("chose_course"){ 
                                                    done = !MoshCourses::Course.all.empty?
                                                    if done
                                                        val = getAnInteger(1, MoshCourses::Course.all.length)
                                                        
                                                        self.openedCourse = MoshCourses::Course.getCourse(val-1)
                                                        #self.openedCourse.printCurrentPage	
                                                        send(Menu["showOpenC"][:bloc])	
                                                        self.deepState += 1										
                                                    end
                                                    return done
                                                }
                },
        "showOpenC" => {label: "View previous page",
                deep_state: 3,
                bloc: define_method("print_course"){   
                                                    self.openedCourse.show
                                                    self.deepState += 1				
                                                    return true 	
                                                }
                },
        "describeC" => {label: "View the course page",
                deep_state: 4,
                bloc: define_method("print_course_detail"){   
                                                    self.openedCourse.showSection
                                                    return true 	
                                                }
                },
        "exit" => {label: "Exit",
                deep_state: 0,
                bloc: define_method("done"){ puts "Done !"
                                                return true if self.deepState == 1
                                                self.deepState += -1
                                                return false
                                            }
                }
    }

    def terminated?(opt)#(round)
        finishing = false
        if opt == "exit" # round > 0
            puts "\ndo you want to exit the program?(y/n)"
            finishing = gets.strip.chars[0].downcase == "y" ? true : false 
        end
        finishing
    end

    def getAnInteger(from, to)
        count = 0
        cInt = ""
        m = /\A\d+\z/
        while !(cInt.validate(m) && (from..to).cover?(cInt.to_i))
            puts "Invalid number.\n Please choose again : " if count>0
            cInt = gets.strip
            count += 1
        end
        cInt.to_i
    end

    def getCourseName
        count = 0
        cCname = ""
        m = /\A[a-zA-Z\s]+\z/
        while !cCname.validate(m) 
            puts "Invalid search option.\n Please choose again : " if count>0
            cCname = gets.strip
            count += 1
        end
        cCname
    end

    def getCommand
        count = 0
        cCmd = ""
        m = /\A[a-zA-Z]+\z/
        while !cCmd.validate(m) 
            puts "Invalid command.\n Please choose again : " if count>0
            cCmd = gets.strip
            count += 1
        end
        cCmd
    end

    def init
        MoshCourses::Course.create_from_collection(MoshCourses::MoshScraper.new.getCourses)
    end

    def running
        count = 0
        opt = ''
        exit = false
        self.init
        
        while !terminated?(opt)#(count)
            mCount = 0
            puts "\n\n\t\tWELCOME to my Mosh courses library App\n".blue if count < 1
            puts "\tHere is the menu: "
            Menu.each{|k, o| puts "\t\t#{mCount += 1} - #{o[:label]} (#{k.to_s.blue})" if o[:deep_state] == deepState || o[:deep_state] == 0 }
            puts "\tWhat do you want to do?"
            puts "\tWrite the command inside () of each menu option to choose the one you want to work with :\n"
            opt = getCommand#gets.strip
            
            #puts "#{opt} - #{Menu[opt][:label]}"
            exit = (send Menu[opt][:bloc]) && (opt == 'exit')
            break if exit
            
            count += 1
        end
    end
end
class MoshCourses::CLI
    attr_accessor :openedCourse, :deepState
    def initialize
        self.deepState = 1
    ends

    def call
        # enter your code here
        # puts "hello you"
        running
    end



    Menu ={ "list" => {label: "List all openClassroom courses",
                deep_state: 1,
                bloc: define_method("list_courses"){
                                                        done = false
                                                        if !MoshCourses::Course.all.empty?
                                                            puts "Here is the Coourses list on openClassroom: \n\n" 
                                                            MoshCourses::Course.all.each_with_index{|c, i| c.toPrint(i) }
                                                            done = true
                                                        else
                                                            puts "There is no course availaible on openClassroom. List is Empty"
                                                        end
                                                        self.openedCourse = nil
                                                        self.deepState += 1
                                                        return done
                                                    }
                },
        "search" => {label: "Search a course by matching name",
                deep_state: 1,
                bloc: define_method("find_course"){ 
                                                    puts "implementation loading"
                                                    self.deepState += 1
                                                }
                },
        "choose" => {label: "Choose a course",
                deep_state: 2,
                bloc: define_method("find_course"){ 
                                                    done = !MoshCourses::Course.all.empty?
                                                    if done
                                                        val = getAnInteger(1, MoshCourses::Course.all.length)
                                                        
                                                        self.openedCourse = MoshCourses::Course.getCourse(val-1)
                                                        #self.openedCourse.printCurrentPage	
                                                        send(Menu["currPage"][:bloc])	
                                                        self.deepState += 1										
                                                    end
                                                    return done
                                                }
                },
        "prevPage" => {label: "View previous page",
                deep_state: 3,
                bloc: define_method("print_course"){   
                                                    self.openedCourse.printPreviousPage
                                                    return true 	
                                                }
                },
        "currPage" => {label: "View current page",
                deep_state: 3,
                bloc: define_method("print_course"){   
                                                    self.openedCourse.printCurrentPage
                                                    return true 	
                                                }
                },
        "nextPage" => {label: "View next page",
                deep_state: 3,
                bloc: define_method("print_course"){ 
                                                    self.openedCourse.printNextPage	
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

    def terminated?(round)
        finishing = false
        if round > 0
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

    def initialised
        MoshCourses::Course.create_from_collection(MoshCourses::ScraperMosh.scrape_courses_page)
        MoshCourses::Course.all.each{|c| c.add_attribute(scrape_course_detail_page(c.profile_url))}
    end

    def running
        count = 0
        exit = false
        self.initialised
        
        while !terminated?(count)
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
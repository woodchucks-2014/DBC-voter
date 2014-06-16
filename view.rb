class View
  def self.get_input
    gets.strip
  end

  def self.welcome
    #get username from user (& password when implemented)
    #returns username to controller
    #send back to the login model via controller
    #print ascii art and user name ('welcome back') or ('new user created')

    puts "Welcome to DBC Voter!!"
    puts "Where you can create subjects, answer them, and vote on the best answers!"
    puts "What is your username?"
  end

  def self.subjects_menu(subjects, username)
    clear_screen

    puts "Welcome, #{username}"
    puts "".ljust(2) + "#".ljust(2)+"|Submitter".ljust(14) + "Subject Title"
    puts "--------------------------------------------------------------------------"
    subjects.each_with_index{|subject, index|
      print "".ljust(2) + "#{index + 1}".ljust(2)+"|#{subject.submitter}".ljust(14)+"#{subject.subject_name}"
      puts
    }
  end

  def self.subjects_menu_options
    puts "--------------------------------------------------------------------------"
    puts
    puts "Which number subject would you like to view?"
    puts "Or type add to add a new subject"
    puts "Or type quit to exit"
  end

  def self.new_subject
    puts "--------------------------------------------------------------------------"
    puts
    puts "Enter the subject you would like to add"
  end

  def self.view_answers(answers, subject)
    #displays all the answers for chosen subject - ranked by number of votes
    #displays number of votes
    #option to add answer
    #option to vote
    clear_screen

    puts subject
    puts "-------------------------------------------------------"
    puts "#".ljust(3) + "|VTS|".ljust(7) + "Answer"
    puts "-------------------------------------------------------"
    answers.each_with_index { |(answer, votes), index|
      print "#{index + 1}.".ljust(3) + "|".ljust(2) + "#{votes}".ljust(2)+ "|".ljust(3) + "#{answer}"
      puts
    }
    puts
  end

  def self.answers_menu_options
    puts "Select an answer to vote up by number"
    puts "Or type add to add a new answer"
    puts "Or type back to go back to Main"
  end

  def self.new_answer
    #takes a new answer from the user
    #submits to db
    puts "Write a new answer for this question"
  end

  def self.clear_screen
    system('clear')
  end
end

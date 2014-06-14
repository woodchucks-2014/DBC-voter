class View

def self.welcome
#get username from user (& password when implemented)
#returns username to controller
#send back to the login model via controller
#print ascii art and user name ('welcome back') or ('new user created')

  puts "Welcome to DBC Voter!!"
  puts "Where you can create subjects, answer them, and vote on the best answers!"
  puts "What is your username?"
  username = gets.chomp
  username.strip
end

def self.subjects_menu(subjects, username)
  system('clear')
  puts "Welcome, #{username}"
  puts "#".ljust(3)+"Subject Title".ljust(45)+"|Submitter".ljust(10)
  puts "--------------------------------------------------------------------------"
  subjects.each_with_index{|(k,v), index|
    print "#{index + 1}.".ljust(3)+"#{k}".ljust(45)+"|#{v}".ljust(10)
    puts
  }
end

def self.subjects_menu_options
  puts "--------------------------------------------------------------------------"
  puts
  puts "Which number subject would you like to view?"
  puts "Or type add to add a new subject"
  puts "Or type quit to exit"
  x = gets.chomp
  x.strip
end

#is sent list of subjects from model db
#looping interface
#shows list of subjects
#option to view answers (by line number)
#option to add subject

def self.new_subject
  puts "--------------------------------------------------------------------------"
  puts
  puts "Enter the subject you would like to add"
  x = gets.chomp
  x.strip
end


def self.view_answers(answers, subject_name)
  system('clear')
  puts subject_name
  puts "-------------------------------------------------------"
  puts "#".ljust(3) + "|UP|".ljust(5) + "Answer"
  puts "-------------------------------------------------------"
  answers.each_with_index { |(answer, votes), index|
    print "#{index + 1}.".ljust(3) + "|#{votes}|".ljust(5) + "#{answer}"
    puts
  }
  puts
#displays all the answers for chosen subject - ranked by number of votes
#displays number of votes
#option to add answer
#option to vote
end

def self.answers_menu_options
  puts "Select an answer to vote up by number"
  puts "Or type add to add a new answer"
  puts "Or type back to go back to Main"
  x = gets.chomp
  x.strip
end

def self.new_answer
  puts "Write a new answer for this question"
  x = gets.chomp
  x.strip
#takes a new answer from the user
#submits to db
end


end
#VIEWS
# login / welcome
###user page
###password
# view subjects
#   view answers
#     vote
  ###comment
#   add answer

# add subjects

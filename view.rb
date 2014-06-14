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
end

def self.subjects_menu(subjects)
  puts "#".ljust(3)+"Subject Title".ljust(45)+"|Submitter".ljust(10)
  puts "--------------------------------------------------------------------------"
  subjects.each_with_index{|element, index|
    print "#{index + 1}.".ljust(3)+"#{element[0]}".ljust(45)+"|#{element[1]}".ljust(10)
    puts
  }
end

def self.subjects_menu_options
  puts "--------------------------------------------------------------------------"
  puts
  puts "Which number subject would you like to view?"
  puts "Or type add to add a new subject"
  x = gets.chomp
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
  end


def self.view_answers(answers)

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
x = gets.chomp
end

def self.new_answer
puts "Write a new answer for this question"
x = gets.chomp
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

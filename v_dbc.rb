class Controller
def initialize
  @username = ''
end

def program_loop
  @username = Model.login(View.welcome)
  puts @username
end
#display welcome view
#receive the username from welcome view
#pass the username to login model

#receive authentication from login model either way
#display subjects_menu view
#receive option variable from subjects view and pass through to view answers or create subject
#   option 1 - view answers
#   option 2 - create subjects - takes input from user, creates subject in db
#   takes you to view answers for just created subject
#controller sends answers from db view answers
end

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
  #is sent list of subjects from model db
  #looping interface
  #shows list of subjects
  #option to view answers (by line number)
  #option to add subject
end

def self.view_answers(answers)
#displays all the answers for chosen subject - ranked by number of votes
#displays number of votes
#option to add answer
#option to vote
end

def self.add_answer
#takes a new answer from the user
#submits to db
end

end

class Model
  def self.login(username)
  #connect to the db and authenticate username
  #else creates a new user
  #returns the username which is saved for the session
  userdata = "Greg"
  if username == userdata
    return userdata
  else
    return username + 'new'
  end
end
end

vdbc = Controller.new
vdbc.program_loop
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


#MODEL - DB ACCESS


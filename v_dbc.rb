require_relative "view.rb"
require_relative "models.rb"

class Controller
def initialize
  @username = ''
  @model = Model.new
end

def program_loop
  system('clear')
  @username = @model.login(View.welcome)
  loop do
  puts "Welcome #{@username}"
  subject_choice = subjects_module
  system('clear')
  answers_module(subject_choice)
  system('clear')
end
end

def subjects_module
  subjects = @model.load_subjects
  View.subjects_menu(subjects)
  subject_choice = View.subjects_menu_options
  if subject_choice == "add"
    subject_string = View.new_subject
    new_subject_id = @model.add_subject(subject_string)
    return new_subject_id
  end
  subject_choice
end

def answers_module(subject_choice)
  answers = @model.load_answers(subject_choice.to_i)
  View.view_answers(answers)
  answer_choice = View.answers_menu_options
  if answer_choice == 'add'
    answer_string = View.new_answer
    @model.add_answer(answer_string, subject_choice.to_i)
    View.view_answers(answers)
  end

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





vdbc = Controller.new
vdbc.program_loop



#MODEL - DB ACCESS


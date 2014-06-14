require_relative "view.rb"
require_relative "models.rb"

class Controller
def initialize
  @username = ''
  @model = Model.new
end

def program_loop
  @username = @model.login(View.welcome)
  loop do
  subject_choice = subjects_sequence
  break if subject_choice == 'quit'
  answers_sequence(subject_choice) if !subject_choice.nil?
end
end

def subjects_sequence
  subjects_full_load = @model.load_subjects
  subjects = subjects_full_load[0]
  subjects_by_index = @model.assign_id_indices(subjects_full_load[1])
  View.subjects_menu(subjects)
  subject_choice = View.subjects_menu_options
  if subject_choice == "add"
    subject_string = View.new_subject
    new_subject_id = @model.add_subject(subject_string) if !subject_string.empty?
    return new_subject_id
  end
  subjects_by_index[subject_choice.to_i].to_i
end

def answers_sequence(subject_choice)
  answers_full_load = @model.load_answers(subject_choice)
  answers_hash = answers_full_load[0]
  votes_hash = answers_full_load[1]
  View.view_answers(votes_hash)
  answers_with_index = @model.assign_id_indices(answers_hash)
  answer_choice = View.answers_menu_options
  if answer_choice == 'add'
    answer_string = View.new_answer
    @model.add_answer(answer_string, subject_choice.to_i) if !answer_string.empty?
  elsif answer_choice.length == 1
    answer_choice = answer_choice.to_i
    if answer_choice != 0
      @model.vote(answers_with_index[answer_choice])
    end
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


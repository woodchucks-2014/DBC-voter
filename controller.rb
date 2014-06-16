class Controller
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

  def program_loop
    View.welcome

    @username = Model.login(View.get_input)

    loop do
      subject_array = subjects_sequence

      break if subject_array == 'quit'

      answers_sequence(subject_array) if subject_array.first != 0
    end
  end

  def subjects_sequence
    subjects_data = Model.load_subjects
    subject_display = subjects_data[0]
    subjects_by_index = Model.assign_id_indices(subjects_data[1])
    View.subjects_menu(subject_display, @username)
    View.subjects_menu_options
    subject_choice = View.get_input
    return 'quit' if subject_choice.downcase == 'quit'
    if subject_choice.downcase == "add"
      View.new_subject
      subject_string = View.get_input
      new_subject_id = Model.add_subject(subject_string) if !subject_string.empty?
      return [new_subject_id, subject_string]
    end
    subject_choice = subject_choice.to_i
    if subjects_by_index[subject_choice] != nil
      subject_array = [subjects_by_index[subject_choice], subject_display.keys[subject_choice - 1]]
    else
      return [0]
    end
  end

  def answers_sequence(subject_array)
    subject_choice, subject_name = subject_array
    loop do
      answers_hash, votes_hash = Model.sort_answers(Model.load_answers(subject_choice))
      answers_with_index = Model.assign_id_indices(answers_hash)
      View.view_answers(votes_hash, subject_name)
      View.answers_menu_options
      answer_choice = View.get_input
      return if answer_choice.downcase == 'back'
      if answer_choice.downcase == 'add'
        View.new_answer
        answer_string = View.get_input
        Model.add_answer(answer_string, subject_choice.to_i) if !answer_string.empty?
      elsif answer_choice.length >= 1
        answer_choice = answer_choice.to_i
        Model.vote(answers_with_index[answer_choice], subject_choice) if answer_choice != 0 && answers_with_index[answer_choice] != nil
      end
    end
  end
end

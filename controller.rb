class Controller
  #display welcome view
  #receive the user from welcome view
  #pass the user to login model

  #receive authentication from login model either way
  #display subjects_menu view
  #receive option variable from subjects view and pass through to view answers or create subject
  #   option 1 - view answers
  #   option 2 - create subjects - takes input from user, creates subject in db
  #   takes you to view answers for just created subject
  #controller sends answers from db view answers

  def program_loop
    View.welcome

    @user = Model::User.login(View.get_input)

    loop do
      subject = subjects_sequence

      break unless subject

      answers_sequence(subject)
    end
  end

  def subjects_sequence
    # Returns either an existing subject or creates a new subject

    subjects = Model::Subject.all

    subjects_by_index = Model.assign_id_indices(subjects)

    View.subjects_menu(subjects, @user.username)
    View.subjects_menu_options

    subject_choice = View.get_input

    return nil if subject_choice.downcase == 'quit'

    if subject_choice.downcase == "add"
      View.new_subject
      subject_string = View.get_input

      unless subject_string.empty?
        subject = Model::Subject.new(subject_name: subject_string, user_id: @user.id).save
      end
    end

    subject_choice = subject_choice.to_i

    if subject = subjects_by_index[subject_choice]
      subject
    else
      return nil
    end
  end

  def answers_sequence(subject)
    loop do
      answers_hash, votes_hash = Model.sort_answers(Model.load_answers(subject.id))
      answers_with_index = Model.assign_id_indices(answers_hash)
      View.view_answers(votes_hash, subject)
      View.answers_menu_options
      answer_choice = View.get_input
      return if answer_choice.downcase == 'back'
      if answer_choice.downcase == 'add'
        View.new_answer
        answer_string = View.get_input
        Model.add_answer(answer_string, subject.id, @user.username) if !answer_string.empty?
      elsif answer_choice.length >= 1
        answer_choice = answer_choice.to_i
        Model.vote(answers_with_index[answer_choice], subject.id, @user.username) if answer_choice != 0 && answers_with_index[answer_choice] != nil
      end
    end
  end
end

require 'sqlite3'

class Model
  def initialize
     @db = SQLite3::Database.open "voter.db"
  end

  def user_exists?(userdata)
    @name = @db.execute("SELECT id, username FROM users WHERE username = ?", userdata)
    @name.flatten!
    !@name.empty?
  end

  def new_user(userdata)
    @db.execute("INSERT INTO users(username) VALUES (?)", userdata)
    @name = @db.execute("SELECT id, username FROM users WHERE username = ?", userdata)
    @name.flatten!
  end

  def login(username)
    #connect to the db and authenticate username
    #else creates a new user
    #returns the username which is saved for the session
    if user_exists?(username)
      return username
    else
      new_user(username)
      return username
    end
  end

  def load_subjects
    subject_display = @db.execute("SELECT subject_name, username FROM subjects JOIN users ON (users.id = subjects.user_id)")
    subjects_id_hash = @db.execute("SELECT id, subject_name FROM subjects")
    #being lazy, pulling subject_name in "subjects_id_hash" only for easy Hash conversion.
    #It is not actually used, see what assign_id_indices does to it
    #Refactor needed - should load all in one query and then parse
    [Hash[subject_display], Hash[subjects_id_hash]]
  end

  def add_subject(subject)
    @db.execute("INSERT INTO subjects(subject_name, user_id) VALUES (?, ?)", subject, @name[0])
    id = @db.execute("SELECT MAX(id) FROM subjects")
    id.flatten.first
  end

  def load_answers(subject_id)
    answers_id_hash = @db.execute("SELECT answer_id, COUNT(votes.answer_id) FROM votes WHERE subject_id = (?) GROUP BY answer_id", subject_id)
    answers_display_hash = @db.execute("SELECT answer_text, COUNT(answer_id) FROM votes INNER JOIN answers ON (answers.id=votes.answer_id) WHERE answers.subject_id = ? GROUP BY answer_id", subject_id)
    [Hash[answers_id_hash], Hash[answers_display_hash]]
  end

  def sort_answers(answers)
    answers_id_hash = answers[0].sort_by{|k,v| v}.reverse
    answers_display_hash = answers[1].sort_by{|k,v| v}.reverse
    [answers_id_hash, answers_display_hash]
  end

  def assign_id_indices(hash)
    id_with_index = {}
    hash.each_with_index{|(k, v), i| id_with_index[i+1] = k}
    id_with_index
  end

  def add_answer(answer, subject_id)
    @db.execute("INSERT INTO answers(answer_text, user_id, subject_id) VALUES (?, ?, ?)", answer, @name[0], subject_id)
    new_answer_id = @db.execute("SELECT MAX(id) FROM answers")
    @db.execute("INSERT INTO votes(answer_id, subject_id, user_id) VALUES (?, ?, ?)", new_answer_id, subject_id, @name[0])
  end

  def vote(answer_id, subject_choice)
    voted = @db.execute("SELECT id FROM votes WHERE user_id = (?) AND answer_id = (?)", @name[0], answer_id)
    if voted.empty?
      @db.execute("INSERT INTO votes(answer_id, subject_id, user_id) VALUES (?, ?, ?)", answer_id, subject_choice, @name[0])
    end
  end
end

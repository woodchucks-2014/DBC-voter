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
      puts "Welcome new user!"
      return username
    end
  end

  def load_subjects
    subjects_for_print = @db.execute("SELECT subject_name, username FROM subjects JOIN users ON (users.id = subjects.user_id)")
    subjects_for_ops = @db.execute("SELECT id, subject_name FROM subjects")
    #being lazy, pulling subject_name in "subject_for_ops" only for easy Hash conversion
    [subjects_for_print, Hash[subjects_for_ops]]
  end

  def add_subject(subject)
    @db.execute("INSERT INTO subjects(subject_name, user_id) VALUES (?, ?)", subject, @name[0])
    id = @db.execute("SELECT MAX(id) FROM subjects")
    id.flatten.first
  end

  def load_answers(subject_id)
    answers = @db.execute("SELECT answers.id, num_of_votes, answer_text FROM answers INNER JOIN subjects ON (subjects.id = answers.subject_id) INNER JOIN votes ON (answers.id = votes.answer_id) WHERE answers.subject_id = (?)", subject_id)
  end

  def process_answers(answers)
    answers_id_hash = {}
    answers_display_hash = {}
    answers.each_with_index{|elem|
      answers_id_hash[elem[0]] = elem[1]
      answers_display_hash[elem[2]] = elem[1]
    }

    answers_display_hash = answers_display_hash.sort_by{|k,v| v}.reverse
    answers_id_hash = answers_id_hash.sort_by{|k,v| v}.reverse

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
    @db.execute("INSERT INTO votes(answer_id, subject_id) VALUES (?, ?)", new_answer_id, subject_id)
  end

  def vote(answer_id)
    @db.execute("UPDATE votes SET num_of_votes = num_of_votes + 1 WHERE answer_id = (?)", answer_id)
  end
end

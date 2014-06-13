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

  def new_user(username)
    @db.execute("INSERT INTO users(username) VALUES (?)", username)
    puts "New User Created #{username}"
    username
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
    subjects = @db.execute("SELECT subject_name, username FROM subjects JOIN users ON (users.id = subjects.user_id)")
  end

  def add_subject(subject)
    @db.execute("INSERT INTO subjects(subject_name, user_id) VALUES (?, ?)", subject, @name[0])
    new_subject_id = @db.execute("SELECT MAX(id) FROM subjects")
    new_subject_id.first.first
  end

  def load_answers(subject_id)
  answers = @db.execute("SELECT answer_text FROM answers JOIN subjects ON (subjects.id = answers.subject_id) WHERE subject_id = (?)", subject_id)

  end

  def add_answer(answer, subject)
  @db.execute("INSERT INTO answers(answer_text, user_id, subject_id) VALUES (?, ?, ?)", answer, @name[0], subject)
  end
end

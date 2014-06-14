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
    puts "New User Created #{userdata}"
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
    subjects = @db.execute("SELECT subject_name, username FROM subjects JOIN users ON (users.id = subjects.user_id)")
  end

  def add_subject(subject)
    @db.execute("INSERT INTO subjects(subject_name, user_id) VALUES (?, ?)", subject, @name[0])
    new_subject_id = @db.execute("SELECT MAX(id) FROM subjects")
    new_subject_id.first.first
  end

  def load_answers(subject_id)
    answers = @db.execute("SELECT answers.id, answer_text FROM answers INNER JOIN subjects ON (subjects.id = answers.subject_id) WHERE answers.subject_id = (?)", subject_id)
    votes = @db.execute("SELECT answer_text, num_of_votes FROM votes INNER JOIN answers ON (answers.id=votes.answer_id) WHERE votes.subject_id = ?", subject_id)
    #this could use some refactoring, - first one needs another join - but functionality is required for the program to display answers by most upvoted
    answers_hash = Hash[answers] #new hash, key => value is answers.id => answer_text
    votes_hash = Hash[votes]  #new hash, key => value is answer_text => num_of votes
    answers_hash.each_with_index{|(k,v), index| answers_hash[k] = votes_hash.values[index]} #re-maps the answers_hash to be answers.id => num_of_votes
    answers_hash = answers_hash.sort_by{|k,v| v}.reverse #sorts by numbers of votes value and reverses (highest first)
    votes_hash = votes_hash.sort_by{|k,v| v}.reverse #sorts by numbers of votes value and reverses (highest first)

    [answers_hash, votes_hash] #packs both hashes into an array to return to controller
  end

  def assign_answer_indices(answers)
    answers_with_index = {}
    i = 1
    answers.each{|k, v| answers_with_index[i] = k
    i += 1
    }
    answers_with_index
  end

  def add_answer(answer, subject_id)
    @db.execute("INSERT INTO answers(answer_text, user_id, subject_id) VALUES (?, ?, ?)", answer, @name[0], subject_id)
    new_answer_id = @db.execute("SELECT MAX(id) FROM answers")
    @db.execute("INSERT INTO votes(answer_id, subject_id) VALUES (?, ?)", new_answer_id, subject_id)
  end

  def vote(answer_id)
    totalvotes = @db.execute("SELECT num_of_votes FROM votes WHERE answer_id = ?", answer_id)
    totalvotes = (totalvotes.first.first) + 1
    @db.execute("UPDATE votes SET num_of_votes=(?) WHERE answer_id = (?)", totalvotes, answer_id)
  end
end

require 'sqlite3'

class Model
  DB = SQLite3::Database.open "voter.db"

  class User
    attr_reader :username, :id

    def initialize(username, id = nil)
      @username = username
      @id = id
    end

    def save
      if new_record?
        DB.execute("INSERT INTO users (username) VALUES (?);", username)
        @id = DB.last_insert_row_id
      else
        DB.execute("UPDATE users SET username = ? WHERE id = ?", username, id)
      end
      self
    end

    def new_record?
      id.nil?
    end

    def to_s
      username
    end

    def self.login(username)
      #connect to the db and authenticate username
      #else creates a new user
      #returns the user which is saved for the session
      if user = User.find('username', username)
        return user
      else
        user = User.new(username)
        user.save

        return user
      end
    end

    def self.find(field, value)
      record = DB.execute("SELECT * FROM users WHERE #{field} = ?", value).first

      # Sometimes record will be nil, in which case we should not
      # attempt to create a user but instead return nil
      if record
        from_record( record )
      else
        nil
      end
    end

    def self.from_record(record)
      # The database will return back records as an array of [id, username]
      new(record[1], record[0])
    end
  end

  class Subject
    attr_reader :id, :subject_name, :user_id

    def initialize(attrs = {})
      @id = attrs.fetch(:id)
      @subject_name = attrs.fetch(:subject_name)
      @user_id = attrs.fetch(:user_id)
    end

    def submitter
      User.find('id', self.user_id)
    end

    def save
      if new_record?
        DB.execute("INSERT INTO subjects (subject_name, user_id) VALUES (?);", [subject_name, user_id])
        @id = DB.last_insert_row_id
      else
        DB.execute("UPDATE subjects SET subject_name = ?, user_id = ? WHERE id = ?", [subject_name, user_id, id])
      end
      self
    end

    def new_record?
      id.nil?
    end

    def to_s
      subject_name
    end

    def self.all
      records = DB.execute("SELECT * FROM subjects;")

      records.map do |record|
        from_record( record )
      end
    end

    def self.from_record(record)
      # The database will return back records as an array of
      # [id, subject_name, user_id, created_at, updated_at]
      new(id: record[0], subject_name: record[1], user_id: record[2])
    end
  end

  def self.load_answers(subject_id)
    answers_id_hash = DB.execute("SELECT answer_id, COUNT(votes.answer_id) FROM votes WHERE subject_id = (?) GROUP BY answer_id", subject_id)
    answers_display_hash = DB.execute("SELECT answer_text, COUNT(answer_id) FROM votes INNER JOIN answers ON (answers.id=votes.answer_id) WHERE answers.subject_id = ? GROUP BY answer_id", subject_id)
    [Hash[answers_id_hash], Hash[answers_display_hash]]
  end

  def self.sort_answers(answers)
    answers_id_hash = answers[0].sort_by{|k,v| v}.reverse
    answers_display_hash = answers[1].sort_by{|k,v| v}.reverse
    [answers_id_hash, answers_display_hash]
  end

  def self.assign_id_indices(enum)
    id_with_index = {}
    enum.each_with_index{|elem, i| id_with_index[i+1] = elem}
    id_with_index
  end

  def self.add_answer(answer, subject_id, username)
    DB.execute("INSERT INTO answers(answer_text, user_id, subject_id) VALUES (?, ?, ?)", answer, username, subject_id)
    new_answer_id = DB.execute("SELECT MAX(id) FROM answers")
    DB.execute("INSERT INTO votes(answer_id, subject_id, user_id) VALUES (?, ?, ?)", new_answer_id, subject_id, username)
  end

  def self.vote(answer_id, subject_choice, username)
    voted = DB.execute("SELECT id FROM votes WHERE user_id = (?) AND answer_id = (?)", username, answer_id)
    if voted.empty?
      DB.execute("INSERT INTO votes(answer_id, subject_id, user_id) VALUES (?, ?, ?)", answer_id, subject_choice, username)
    end
  end
end

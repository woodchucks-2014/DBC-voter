require "sqlite3"
db = SQLite3::Database.new "voter.db"

db.execute <<SQL
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username VARCHAR(64) NOT NULL
  );
SQL

db.execute <<SQL
CREATE TABLE IF NOT EXISTS subjects (
id INTEGER PRIMARY KEY AUTOINCREMENT,
subject_name TEXT NOT NULL,
user_id INTEGER NOT NULL,
FOREIGN KEY(user_id) REFERENCES users(id)
);
SQL


db.execute <<SQL
CREATE TABLE IF NOT EXISTS answers (
id INTEGER PRIMARY KEY AUTOINCREMENT,
answer_text TEXT NOT NULL,
user_id INTEGER NOT NULL,
subject_id INTEGER NOT NULL,
FOREIGN KEY(user_id) REFERENCES users(id),
FOREIGN KEY(subject_id) REFERENCES subjects(id)
);
SQL


db.execute <<SQL
CREATE TABLE IF NOT EXISTS votes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  answer_id INTEGER NOT NULL,
  subject_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(answer_id) REFERENCES answers(id)
  FOREIGN KEY(subject_id) REFERENCES subjects(id)
  FOREIGN KEY(user_id) REFERENCES users(id)
  );
SQL

# db.execute(

#   "INSERT INTO subjects (user_id)" +
#   "VALUES (8765654)"
#   )

# db.execute( "SELECT * FROM subjects" ) do |subject|
#   puts subject
# end

# CREATE TABLE answers


# CREATE TABLE answers
# (
# id INTEGER PRIMARY KEY AUTOINCREMENT,

#   )





#1027692

require 'rake'

namespace 'db' do
  desc 'Export to CSV'
  task :export do
    `sqlite3 -csv voter.db "SELECT * FROM users;" > data/users.csv`
    `sqlite3 -csv voter.db "SELECT * FROM subjects;" > data/subjects.csv`
    `sqlite3 -csv voter.db "SELECT * FROM answers;" > data/answers.csv`
    `sqlite3 -csv voter.db "SELECT * FROM votes;" > data/votes.csv`
  end
end

require_relative "view.rb"
require_relative "models.rb"
require_relative "controller.rb"

vdbc = Controller.new
vdbc.program_loop

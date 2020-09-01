class Students::StudentsController < ApplicationController
  layout 'student'

  before_action :require_student
end
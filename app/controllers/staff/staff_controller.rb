class Staff::StaffController < ApplicationController
  layout 'staff'

  before_action :require_staff
end
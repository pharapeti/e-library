class Staff::DashboardController < Staff::StaffController
  def show
    @books = Book.active.limit(3)
  end
end
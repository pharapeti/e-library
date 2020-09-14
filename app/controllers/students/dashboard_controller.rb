class Students::DashboardController < Students::StudentsController
  def show
    @books = Book.active.limit(3)
  end
end
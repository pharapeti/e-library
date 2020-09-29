class LibraryManagers::DashboardController < LibraryManagers::LibraryManagersController
  def show
    @books = Book.active.limit(3)
  end
end

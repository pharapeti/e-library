class Staff::BooksController < Staff::StaffController
  before_action :set_book
  before_action :ensure_no_fines

  def borrow
    loan = Loan.new(book: @book, user: current_user, borrowed_at: Time.now)

    respond_to do |format|
      if loan.save
        format.html { redirect_to book_path(@book), notice: 'Book was borrowed successfully.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def ensure_no_fines
    if current_user.has_overdue_loans?
      redirect_to @book, alert: 'You cannot borrow this book as you have an outstanding fine.' and return
    end
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :reference_number, :edition, :active, :book_type, :author)
  end
end

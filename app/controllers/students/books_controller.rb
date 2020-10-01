class Students::BooksController < Students::StudentsController
  before_action :set_book, only: :borrow

  def borrow
    loan = Loan.new(book: @book, user: current_user, borrowed_at: Time.now)

    respond_to do |format|
      if loan.save
        if @book.
        format.html { redirect_to book_path(@book), notice: 'Book was borrowed successfully.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :reference_number, :edition, :active, :book_type, :author)
  end
end

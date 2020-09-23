class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :set_loan, only: %i[show]
  # before_action :require_library_manager, only: %i[edit update destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @loan = Loan.find_by(book: @book, user: current_user, returned_at: nil)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book.cover_image.attach(params[:cover_image])
    @book.content.attach(params[:content])

    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def return
    @book = Book.find(params['book_id'])
    @loan = Loan.find_by(book: @book, user: current_user)

    if @loan.update(returned_at: Time.now)
      redirect_to @book, notice: 'Book was successfully returned.'
    else
      redirect_to @book, alert: 'Could not return book.'
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  def set_loan
    @loan = Loan.find_by(book: @book, user: current_user, returned_at: nil)
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:id, :cover_image, :content)
  end
end

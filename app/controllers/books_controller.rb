class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy return]
  before_action :set_loan, only: %i[show return]
  before_action :require_library_manager, only: %i[new create edit update destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
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

    # Files are not auto-attached
    @book.cover_image.attach(params[:book][:cover_image])
    @book.content.attach(params[:book][:content])

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
    if @loan.update(returned_at: Time.now)
      redirect_to @book, notice: 'Book was successfully returned.'
    else
      redirect_to @book, alert: 'Could not return book.'
    end
  end

  def renew
    @book = Book.find(params['book_id'])
    @loan = Loan.find_by(book: @book, user: current_user, returned_at: nil)
    
    if @loan.to_be_returned_at < Time.now
      redirect_to @book, alert: 'Book is overdue. Please check your account for late return fees.' and return
    elsif @loan.renewal_no == @book.max_renewal 
      redirect_to @book, alert: 'Failed to renew book. You have reached the renewal limit.' and return
    else
      if @loan.update(renewed_at: Time.now, renewal_no: @loan.renewal_no + 1)
        redirect_to @book, notice: 'Book was successfully renewed.'
      else
        redirect_to @book, alert: 'Failed to renew book.'
      end
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

  def set_book
    @book = Book.find(params[:id] || params['book_id'])
  end

  def set_loan
    @loan = Loan.on_loan.find_by(book: @book, user: current_user)

    redirect_to @book, alert: 'Loan not found' && return if @loan.blank?
  end

  def book_params
    params.require(:book).permit(
      :id, :cover_image, :content, :title, :author, :reference_number,
      :edition, :book_type, :description, :max_copies, :max_renewal
    )
  end
end

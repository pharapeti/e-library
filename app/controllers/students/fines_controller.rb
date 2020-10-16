class Students::FinesController < Students::StudentsController
  before_action :set_book
  before_action :set_loan
  before_action :set_fine

  def pay
    now = Time.now

    @loan.update(returned_at: now)
    @fine.update(charged_at: now)

    redirect_to @book, notice: 'Fine has been paid and the book has been returned successfully.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_loan
    @loan = Loan.on_loan.where(book: @book, user: current_user)&.first

    redirect_to @book, alert: 'Loan not found' && return if @loan.blank?
  end

  def set_fine
    @fine = @loan.fine.presence || @loan.create_fine!(amount: @loan.amount_pending)
  end
end

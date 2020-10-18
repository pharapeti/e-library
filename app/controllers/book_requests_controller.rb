class BookRequestsController < ApplicationController
    before_action :ensure_not_student
    before_action :require_staff, only: %i[new create destroy]

    layout 'shared'

    def index
        @book_requests = BookRequest.all
    end

    def show
        @book_request = BookRequest.find(params[:id])
    end

    def new
        @book_request = BookRequest.new()
    end

    def create 
        @book_request = BookRequest.new(book_request_params)
        @book_request.user = current_user

        respond_to do |format|
            if @book_request.save
                format.html { redirect_to @book_request, notice: 'Book Request was successfully created.' }
                format.json { render :show, status: :created, location: @book_request }
            else
                format.html { redirect_to @book_request, notice: 'Unable to create book request' }
                format.json { render json: @book_request.errors, status: :unprocessable_entity }
            end
        end

    end

    def fulfill
        @book_request = BookRequest.find(params[:id])
        @book_request.fulfillment = true
        respond_to do |format|
            if @book_request.save
                format.html { redirect_to book_requests_path, notice: 'Book Request was successfully marked as fulfilled' }
                format.json { render :show, status: :created, location: @book_request }
            else
                format.html { redirect_to book_requests_path, notice: 'Unable to mark book request as fulfilled.' }
                format.json { render json: @book_request.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @book_request = BookRequest.find(params[:id])
        @book_request.destroy
        respond_to do |format|
            format.html { redirect_to book_requests_url, notice: 'Book Request was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    

    def book_request_params
        params.require(:book_request).permit(:id, :title, :author, :edition)
    end

    def ensure_not_student
        return unless current_user.student? 
        
        redirect_to root_path, notice: 'Sorry, you\'re not allowed to view the page you requested.'
    end

end
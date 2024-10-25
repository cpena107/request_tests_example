class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy accept ]
  # TODO authenticate and authorize the users on the app
  before_action :authenticate_account!

  # GET /books or /books.json
  def index
    if current_account.role_id == 1
      if params[:read] == "true"
        @books = Book.where(read: true)
        @filter = "Read"
      elsif params[:read] == "false"
        @books = Book.where(read: false)
        @filter = "Unread"
      else
        @books = Book.all
        @filter = ""
      end
    else
      if params[:read] == "true"
        @books = Book.where(["read = true and pending_approval = false"])
        @filter = "Read"
      elsif params[:read] == "false"
        @books = Book.where(["read = true and pending_approval = false"])
        @filter = "Unread"
      else
        @books = Book.where(pending_approval: false)
        @filter = ""
      end
    end
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    if current_account.role_id == 1
      @book.pending_approval = false
    end

    respond_to do |format|
      if @book.save
        if current_account.role_id == 0
          format.html { redirect_to book_url(@book), notice: "Successfully recommended book." }
        else
          format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        end
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    if current_account.role_id == 0
      redirect_to root_path
    else
      respond_to do |format|
        if @book.update(book_params)
          format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
          format.json { render :show, status: :ok, location: @book }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def accept
    if current_account.role_id == 0
      redirect_to root_path
    else
      respond_to do |format|
        @book.pending_approval = false
        if @book.save
          format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
          format.json { render :show, status: :ok, location: @book }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    if current_account.role_id == 0
      redirect_to root_path
    else
      @book.destroy!

      respond_to do |format|
        format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
        format.json { head :no_content }
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
      params.require(:book).permit(:title, :read)
    end
end

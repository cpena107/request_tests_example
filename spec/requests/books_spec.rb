require 'rails_helper'

RSpec.describe "Books", type: :request do
  before do
    # Using the factory to create these account/book, go check it out when you need to add roles to accounts, and pending attribute to books
    @book = create(:book, :nonpending)
    @book_pending = create(:book, :pending)
    @Amber = create(:account, :admin)
    @Mary = create(:account, :normal) 
  end

  # happy/sad paths for Amber
  describe "When signed in as Amber" do
    before do
      sign_in @Amber
    end

    #index test
    it "should get index" do
      get books_path
      expect(response).to have_http_status(200)
    end

    # tests for read/unread routes
    context "view read/unread books" do
      it "should get index with read books" do
        get books_path(read: true) # send the route with read=true
        expect(response.body).to include("Read Books") # simple expectation, the response includes the title Read Books. Could be better if we find the title by ID
      end

      it "should get index with read books" do
        get books_path(read: false)
        expect(response.body).to include("Unread Books")
      end
    end
  
    # tests for book creating (as Amber)
    context "creates a book with correct params" do
      it "should get new form" do
        get new_book_path
        expect(response).to have_http_status(200) # new form is accessible if we get 200 status code
      end

      it "creates a book with POST given correct params" do
        expect {
          post books_path, params: {book: {title: "Some title", read: true}}
      }.to change(Book, :count).by 1 # post /books works if the DB gets a new book

        expect(response).to redirect_to(book_path(Book.last)) # The response redirects to the newly created book
        expect(Book.last.pending_approval).to eq(false) # The book does not have a pending status (because Amber created it)
      end

      it "does not create a book with POST given incorrect params" do
        expect {
          post books_path, params: {book: {title: nil, read: true}}
      }.not_to change(Book, :count) # post /books works if the DB does not get a new book (because params are incomplete/incorrect)

        expect(response).to have_http_status(422) # The response is 422 (unprocessable)
        expect(response.body).to include("Title can&#39;t be blank")  # Error message shows stating the missing data

        # now the same thing but with read missing
        expect {
          post books_path, params: {book: {title: "Some book title", read: nil}}
      }.not_to change(Book, :count) # post /books works if the DB does not get a new book (because params are incomplete/incorrect)

        expect(response).to have_http_status(422) # The response is 422 (unprocessable)
        expect(response.body).to include("Read can&#39;t be nil")  # Error message shows stating the missing data
      end
    end

    # tests for editing
    context "updates a books title correctly" do
      it "should get edit page" do
        get edit_book_path(@book)
        expect(response).to have_http_status(200) # edit page is accessible
      end

      it "should update the title" do
        patch book_path(@book), params: {book: {title: "a new title", read: true}} # no expect {} here since patch does not change the DB row count
        expect(Book.find(@book.id).title).to eq("a new title") # We can expect the book we intended to update was updated
        expect(response).to redirect_to(book_path(@book))  # The response redirects to the newly created book
      end

      it "should not update the title" do
        patch book_path(@book), params: {book: {title: nil, read: true}} # again no expect {}
        expect(Book.find(@book.id).title).to eq("MyString") # Expect the book to conserve the initial original title since nil is not a valid one
        expect(response).to have_http_status(422) # The response is 422 (unprocessable)
      end
    end

    # tests for viewing one
    context "reads book that exists" do
      it "should get show" do
        get book_path(@book) # access a book that exists
        expect(response).to have_http_status(:ok) # response should be 200
      end

      it "should not get a book that does not exist" do
        get book_path(999) # access a book that does not exist
        expect(response).to have_http_status(404) # response should be 404 (this could change if the client didn't want to show 404 message)
      end
    end

    # tests for deleting a book
    context "deletes a book" do
      it "should delete a book" do
        expect{
          delete book_path(@book)
      }.to change(Book, :count).by (-1) # trying to delete a book that exists changes the DB row count by -1
      expect(response).to redirect_to(books_url) # response should take us back to index
      end

      it "should not delete a book that does not exist" do
        expect{
          delete book_path(999) 
      }.to change(Book, :count).by (0) # trying to delete a book that does not exist
      expect(response).to have_http_status(404) # response should be 404
      end
    end
  end

  # happy/sad paths for Normal users
  describe "When signed in as mary" do
    before do
      sign_in @Mary
    end

    it "should get index" do
      get books_path
      expect(response).to have_http_status(:ok)
    end
    
    # viewing read/unread (as a normal user), wait these look the same as the ones above... Yes!, but no, the context changed now 
    # Mary is logged in and she does not have the same account as Amber, we still need to test for the same routes as we did for Amber, 
    # some responses will be identical, some will change, but we need to confirm this type of user can access all of our features.
    context "view read/unread books" do
      it "should get index with read books" do
        get books_path(read: true)
        expect(response.body).to include("Read Books")
      end

      it "should get index with read books" do
        get books_path(read: false)
        expect(response.body).to include("Unread Books")
      end
    end
   
    # tests for deleting a book (as a normal user)
    context "delete/reject a book" do
      it "should not delete a book" do
        expect{
          delete book_path(@book)
      }.to change(Book, :count).by (0) # Mary can't delete books, expect the route DELETE /books/:id to not change the DB row count
      expect(response).to redirect_to(root_path) # response is a redirect to index
      end

      it "should not reject a book" do
        expect{
          delete book_path(@book_pending)
      }.to change(Book, :count).by (0) # deleting (rejecting) a book is also not possible for normal users
      expect(response).to redirect_to(root_path)
      end
    end

    # updating books (as a normal user)
    context "update/accept a book" do
      it "should not update a book" do
        patch book_path(@book), params: {book: {title: "a new title", read: true}} # normal users can't update book information
        expect(Book.find(@book.id).title).not_to eq("a new title") # expect the title not to change to the new one
        expect(response).to redirect_to(root_path) # expect response to be a redirect to index
      end

      it "should not accept a book" do
        patch accept_book_path(@book_pending) # updating pending_approval (accepting) a book is not possible for normal users
        expect(Book.find(@book_pending.id).pending_approval).to eq(true) # expect pending to remain true
        expect(response).to redirect_to(root_path) # expect response to be a redirect to index
      end
    end
  end

  # sad paths for non-signed in users (non-signed in users can't do anything in the application)
  # test for every action and expect it not to be possible by this user
  describe "when not signed in" do
    it "should not index" do
      get root_path
      expect(response).to redirect_to(new_account_session_path)
    end

    it "should not create" do
      expect {
          post books_path, params: {book: {title: "Some title", read: true}}
      }.to change(Book, :count).by 0
      expect(response).to redirect_to(new_account_session_path)
    end

    it "should not show" do
      get book_path(@book)
      expect(response).to redirect_to(new_account_session_path)
    end

    it "should not update" do
      patch book_path(@book), params: {book: {title: "a new title", read: true}}
        expect(Book.find(@book.id).title).not_to eq("a new title")
      expect(response).to redirect_to(new_account_session_path)
    end

    it "should not delete" do
      expect{
          delete book_path(@book)
      }.to change(Book, :count).by (0)
      expect(response).to redirect_to(new_account_session_path)
    end
  end

end

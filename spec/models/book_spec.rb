require 'rails_helper'

RSpec.describe Book, type: :model do
  it "should accept valid book" do
    book = Book.create(title: "My book title", read: false)
    expect(book).to be_valid
  end

  it "should reject invalid book" do
    book = Book.create(title: nil, read: true)
    expect(book).not_to be_valid
  end  

  it "should reject invalid book" do
    book = Book.create(title: "The title", read: nil)
    expect(book).not_to be_valid
  end
end

json.extract! book, :id, :title, :read, :created_at, :updated_at
json.url book_url(book, format: :json)

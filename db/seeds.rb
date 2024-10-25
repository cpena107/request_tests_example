# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# UPDATE: Accounts and books must be updated when the app is complete reflecting the new roles for accounts, and attribute of books.
Amber = Account.create(email:"amber@google.com", password: "test123", role_id: 1)
Bookaholic = Account.create(email:"bookuser@google.com", password: "test123", role_id: 0)

book1 = Book.create(title: "Harry Potter", read:false, pending_approval:false)
book2 = Book.create(title: "SaaS An Agile Approach using Cloud Computing", read:true, pending_approval:false)
book3 = Book.create(title: "The Alchemist", read:true, pending_approval:true)
book4 = Book.create(title: "Angels and Demons", read:true, pending_approval:true)
# IF you wish to test this file AFTER completing the project (or while working on it), if the DB was already seeded the users won't be recreated and they won't be updated, you must first drop the tables on your DB (rails db:drop) then re-seed again (rails db:seed).

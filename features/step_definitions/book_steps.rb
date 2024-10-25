Given('I have two users Amber and mary') do
    # modify this accounts when you add role ids
    @amber = Account.create(email: "amber@amber.com", password: "pass123", role_id: 1)
    @mary = Account.create(email: "mary@amber.com", password: "pass123", role_id: 0)
  end
  
  Given('I log in as Amber') do
    visit new_account_session_path
    fill_in "account_email", with: @amber.email
    fill_in "account_password", with: @amber.password
    click_on "Log in"
  end

  Given('I log in as mary') do
    visit new_account_session_path
    fill_in "account_email", with: @mary.email
    fill_in "account_password", with: @mary.password
    click_on "Log in"
  end
  
  When('I click {string}') do |text|
    click_on text
  end
  
  When('I fill out the new book form with {string}') do |title|
    fill_in "book_title", with: title
    click_on "Create Book"
  end
  
  Then('I should be able to see the new book') do
    expect(page).to have_content("Book was successfully created.")
  end
  
  Given('I have books') do
    @book1 = Book.create(title: "Book title", read: false, pending_approval: false)
    @book2 = Book.create(title: "Book title 2", read: true, pending_approval: false)
    @book3 = Book.create(title: "Book title 3", read: true, pending_approval: true)
    @book4 = Book.create(title: "Book title 4", read: false, pending_approval: true)
  end
  
  When('I click {string} on the first book') do |text|
    find("#book_#{@book1.id}").click_on(text)
  end
  
  Then('I should be able to see the deleted book') do
    expect(page).to have_content("Book was successfully destroyed.")
  end
  
  When('I edit the book\'s title') do
    fill_in "book_title", with: "New book title"
    click_on "Update Book"
  end
  
  When('I edit the book\'s read status') do
    find("#book_read").click
    click_on "Update Book"
  end
  
  Then('I should be able to see the edit') do
    expect(page).to have_content("Book was successfully updated.")
  end
  
  When('I go to the homepage') do
    visit root_path
  end
  
  Then('I should be able to see the all the Books') do
    expect(page).to have_content("Books")
    expect(page).to have_content(@book1.title)
    expect(page).to have_content(@book2.title)
  end
  
  Then('I should be able to see that Book') do
    expect(page).to have_current_path(book_path(@book1))
  end
  
  Then('I should be able to see the all the Read Books') do
    expect(page.body).to include(@book2.title)
    expect(page).to have_content("Read Books")
  end
  
  Then('I should be able to see all the Unread Books') do
    expect(page.body).to include(@book1.title)
    expect(page).to have_content("Unread Books")
  end

  # TODO add more steps here (What is missing? Check REST CANVAS!)
  Then('I should be able to see the new book recommendation message') do
    expect(page).to have_content("Successfully recommended book") # Write code here that turns the phrase above into concrete actions
  end
  
  Then('The book is pending approval from Amber') do
    expect(Book.last.pending_approval).to eq(true)
  end
  
  Then('I should be able to see the all the non-pending Books') do
    expect(page).to have_content(@book1.title)
    expect(page).to have_content(@book2.title)
    expect(page).not_to have_content(@book3.title)
    expect(page).not_to have_content(@book4.title)
  end

  When('I click {string} on the first pending book') do |string|
    click_on "#{string}-#{@book3.id}"
  end
  
  Then('I should be able to see that book as non-pending') do
    expect(page).to have_content("Book was successfully updated.")
  end
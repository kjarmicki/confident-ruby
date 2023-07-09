# Conditionally yield to a block on completion rather than returning a value

# this method is used in a program that imports books from one system to another
def import_purchase(date, title, user_email)
  user = User.find_by_email(user_email)
  if user.purchased_titles.include?(title)
    false # already imported
  else
    user.purchases.create(title: title, purchased_at: date)
    true # not imported yet
  end
end

# if the import happens, the user is sent an email inviting them to see the new site
def import_things()
  # ...
  if import_purchase(date, title, user_email)
    send_book_invitation_email(user_email, title)
  end
  # ...
end

# alternative - use callback to signal that the import happened:
def import_purchase_with_callback(date, title, user_email, &import_callback)
  user = User.find_by_email(user_email)
  unless user.purchased_titles.include?(title)
    purchase = user.purchases.create(title: title, purchased_at: date)
    import_callback.call(user, purchase)
  end
end

def import_things_with_callback()
  # ...
  import_purchase(date, title, user_email) do |user, purchase|
    send_book_invitation(user.email, purchase.title)
  end
  # ...
end
# advantages: this can be easily altered to a batch operation:
# pass multiple entries into import_purchases and let callback be called multiple times
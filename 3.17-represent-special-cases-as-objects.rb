# Represent the special case as a unique type of object. Rely on polymorphism to handle the special case correctly when it's found.

# example case: guest account in webapp
def current_user
  if session[:user_id]
    User.find(session[:user_id])
  end
end

# no polymorphism here
def greeting
  "Hello, " + current_user ? current_user.name : "Anonymous" + ", how are you today?"
end

# and here
def render_top_button
  if current_user
    render_logout_button
  else
    render_login_button
  end
end

# and here
def poor_mans_admin_panel
  if current_user && current_user.has_role?(:admin)
    render_admin_panel
  end
end

# and here
def listings
  if current_user
    current_user.visible_listings
  end
  Listing.publicly_visible
end

# and here
def modify_attributes
  if current_user
    current_user.last_seen_online = Time.now
  end
end

# and here
def add_to_cart(item)
  cart = if current_user
           current_user.cart
         else
           SessionCart.new(session)
         end
  cart.add_item(item)
end

# all the above code is uncertain whether current_user will return User or nil
# let's fix it with a GuestUser class

class GuestUser
  def initialize(session)
    @session = session
  end

  def name
    "Anonymous"
  end

  def authenticated?
    false
  end

  def has_role(role)
    false
  end

  def visible_listings
    Listing.publicly_visible
  end

  def last_seen_online=(time)
    # noop
  end

  def cart
    SessionCart.new(@session)
  end
end

def polymorphic_current_user
  if session[:user_id]
    User.find(session[:user_id])
  else
    GuestUser.new(session)
  end
end

def polymorphic_greeting
  "Hello, #{polymorphic_current_user.name}"
end

def polymorphic_render_top_button
  if current_user.authenticated?
    render_logout_button
  else
    render_login_button
  end
end

def polymorphic_poor_mans_admin_panel
  if current_user.has_role?(:admin)
    render_admin_panel
  end
end

def polymorphic_listings
  current_user.visible_listings
end

def polymorphic_modify_attributes
  current_user.last_seen_online = Time.now
end

def polymorphic_add_to_cart(item)
  current_user.cart.add_item(item, 1)
end

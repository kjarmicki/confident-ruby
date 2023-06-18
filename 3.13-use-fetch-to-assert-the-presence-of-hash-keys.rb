# Implicitly assert the presence of the required key with Hash.fetch

def add_user(attributes)
  # fetch raises a KeyError when key is not found
  # [] access just returns nil, so it's indistinguishable from the stored nil value
  login = attributes.fetch(:login)
  password = attributes.fetch(:password) do
    raise KeyError, "password (or false) must be supplied"
  end

  command = %w[useradd]
  if attributes[:home]
    command << '--home' << attributes[:home]
  end
  if attributes[:shell]
    command << '--shell' << attributes[:shell]
  end

  if password == false
    command << '--disabled-login'
  else
    command << '--password' << password
  end

  command << login

  if attributes[:dry_run]
    puts command.join(' ')
  else
    system *command
  end
end

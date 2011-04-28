# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nmb_session',
  :secret      => '077e611400f25879655df6cadab62596fe2b62a6ce9a66baf8098642e0de7885419fdf622a59b698bbc3746c0498f5c21f86e3a6060ed80d2e6a0b5507e7c99b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

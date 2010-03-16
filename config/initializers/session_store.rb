# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ecse321_session',
  :secret      => '99ed240489b957c0e4d8cf0ad9f88dccc9e2d4e751f54adc3a2873b922ce2e0cd29a50c2b9eecead7f0450b5a0b52921c76ad07dba8c683acfa41c8863854741'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

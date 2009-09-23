# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cddb_session',
  :secret      => 'f16c5383c7cd7e38a77924441a1f2e62d0ac94e03c04ef9037740aafc734e0358a9882ebc74e834bfe8216c897ac4bbddbaad609bb5c4e96b8a7cea1a87fc424'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

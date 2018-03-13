object @user
node(:id) { |user| user.id }
node(:email) { |user| user.email }
node(:token) { |user| user.spree_api_key }

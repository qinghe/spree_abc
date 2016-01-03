require 'rails_helper'
describe 'making a request to an unrecognised path' do

#  it 'returns 404' do
#    get '/nowhere'
#    expect(response.status).to eq(404)
#  end
end

# routing
#constraints subdomain: 'api' do
#  namespace :api, path: '', defaults: { format: 'json' } do
#    scope module: :v1, constraints: ApiConstraints.new(1) do
#      # ... actual routes omitted ...
#    end
#    match "*path", to: -> (env) { [404, {}, ['{"error": "not_found"}']] }, via: :all
#  end
#end

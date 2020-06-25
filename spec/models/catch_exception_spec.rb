require 'rails_helper'

describe 'Exception' do

  it 'should catch exception' do
    begin
      raise AbstractController::ActionNotFound
    rescue Exception => exception
      expect( exception ).to be_a  AbstractController::ActionNotFound
    end
  end
end

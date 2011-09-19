require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'recognizes and generates #new' do
      { get: '/session/new' }.should route_to('sessions#new')
      { get: '/sign_in' }.should route_to('sessions#new')
    end

    it 'recognizes and generates #create' do
      { post: '/session' }.should route_to('sessions#create')
    end

    it 'recognizes and generates #destroy' do
      { delete: '/session' }.should route_to('sessions#destroy')
      { get: '/sign_out' }.should route_to('sessions#destroy')
    end
  end
end

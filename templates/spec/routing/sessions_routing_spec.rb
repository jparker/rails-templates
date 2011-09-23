require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'routes to #new' do
      { get: '/session/new' }.should route_to('sessions#new')
    end

    it 'routes to #create' do
      { post: '/session' }.should route_to('sessions#create')
    end

    it 'routes to #destroy' do
      { delete: '/session' }.should route_to('sessions#destroy')
    end

    it 'has a route named "sign_in"' do
      { get: '/sign_in' }.should route_to('sessions#new')
    end

    it 'has a route named "sign_out"' do
      { get: '/sign_out' }.should route_to('sessions#destroy')
    end
  end
end

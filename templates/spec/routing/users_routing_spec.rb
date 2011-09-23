require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #index' do
      { get: '/users' }.should route_to('users#index')
    end

    it 'routes to #show' do
      { get: '/users/42' }.should route_to('users#show', id: '42')
    end

    it 'routes to #new' do
      { get: '/users/new' }.should route_to('users#new')
    end

    it 'routes to #edit' do
      { get: '/users/42/edit' }.should route_to('users#edit', id: '42')
    end

    it 'routes to #create' do
      { post: '/users' }.should route_to('users#create')
    end

    it 'routes to #update' do
      { put: '/users/42' }.should route_to('users#update', id: '42')
    end

    it 'routes to #destroy' do
      { delete: '/users/42' }.should route_to('users#destroy', id: '42')
    end
  end
end

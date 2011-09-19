require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      { get: '/users' }.should route_to('users#index')
    end

    it 'recognizes and generates #show' do
      { get: '/users/42' }.should route_to('users#show', id: '42')
    end

    it 'recognizes and generates #new' do
      { get: '/users/new' }.should route_to('users#new')
    end

    it 'recognizes and generates #edit' do
      { get: '/users/42/edit' }.should route_to('users#edit', id: '42')
    end

    it 'recognizes and generates #create' do
      { post: '/users' }.should route_to('users#create')
    end

    it 'recognizes and generates #update' do
      { put: '/users/42' }.should route_to('users#update', id: '42')
    end

    it 'recognizes and generates #destroy' do
      { delete: '/users/42' }.should route_to('users#destroy', id: '42')
    end
  end
end

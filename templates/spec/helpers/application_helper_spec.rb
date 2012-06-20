require 'spec_helper'

describe ApplicationHelper do
  describe '#link_to_index' do
    let(:users) { [build_stubbed(:user)] }

    it 'links to #index action for given resource' do
      helper.link_to_index(users.first).should eq(helper.link_to('All', helper.users_path, title: 'All'))
    end

    it 'accepts a path option to override link target' do
      helper.link_to_index(users.first, path: '/foo').should eq(helper.link_to('All', '/foo', title: 'All'))
    end

    it 'accepts model class instead of model instance as resource' do
      helper.link_to_index(User).should eq(helper.link_to_index(users.first))
    end
  end

  describe '#link_to_show' do
    let(:user) { build_stubbed(:user) }

    it 'links to #show action for given resource' do
      helper.link_to_show(user).should eq(helper.link_to('View', helper.user_path(user), title: 'View'))
    end

    it 'accepts a path option to override link target' do
      helper.link_to_show(user, path: '/foo').should eq(helper.link_to('View', '/foo', title: 'View'))
    end
  end

  describe '#link_to_new' do
    let(:user) { User.new }

    it 'links to #new action for given resource' do
      helper.link_to_new(user).should eq(helper.link_to('New', helper.new_user_path, title: 'New'))
    end

    it 'accepts a path option to override link target' do
      helper.link_to_new(user, path: '/foo').should eq(helper.link_to('New', '/foo', title: 'New'))
    end
  end

  describe '#link_to_edit' do
    let(:user) { build_stubbed(:user) }

    it 'links to #edit action for given resource' do
      helper.link_to_edit(user).should eq(helper.link_to('Edit', helper.edit_user_path(user), title: 'Edit'))
    end

    it 'accepts a path option to override link target' do
      helper.link_to_edit(user, path: '/foo').should eq(helper.link_to('Edit', '/foo', title: 'Edit'))
    end
  end

  describe '#link_to_destroy' do
    let(:user) { build_stubbed(:user) }

    it 'links to #destroy action for given resource' do
      helper.link_to_destroy(user).should eq(helper.link_to('Delete', helper.user_path(user), title: 'Delete', method: :delete, data: { confirm: 'Are you sure?' }))
    end

    it 'accepts a path option to override link target' do
      helper.link_to_destroy(user, path: '/foo').should eq(helper.link_to('Delete', '/foo', title: 'Delete', method: :delete, data: { confirm: 'Are you sure?' }))
    end
  end
end

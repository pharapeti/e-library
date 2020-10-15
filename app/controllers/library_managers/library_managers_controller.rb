class LibraryManagers::LibraryManagersController < ApplicationController
  layout 'library_manager'

  before_action :require_library_manager
end
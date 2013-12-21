#encoding: utf-8
module Spree
  UsersController.class_eval do
     respond_to :html, :js
     # since redirect_to work in ajax, do not need rewrite 'update'
  end
end
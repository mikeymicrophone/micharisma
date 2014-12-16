class HomeController < ApplicationController
  def enter_mailing_list
    @article = Article.first
  end
end

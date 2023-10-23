# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: "foo@example.com"

  def unused_fields_email
    user = params[:user]
    _projects = Project.all.map(&:name)

    mail(to: user.email) do |format|
      format.text { render plain: "Text" }
    end
  end

  def used_fields_email
    user = params[:user]
    _projects = Project.all.map(&:inspect)

    mail(to: user.email) do |format|
      format.text { render plain: "Text" }
    end
  end
end

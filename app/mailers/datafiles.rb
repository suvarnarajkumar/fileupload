class Datafiles < ActionMailer::Base
  default from: "from@example.com"
  def welcome_email(email,body,file)
    arr = file.split("/")
    attachments[arr[arr.length-1]] = File.read("#{Rails.root}/public"+file)
    mail(:to =>  email, :subject =>  "Welcome to SUVARNA's Awesome Site" )do |format|
    format.text { render :text => body }
  end
  end
end

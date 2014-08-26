class DatafilesController < ApplicationController
  before_action :set_datafile, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
 
  # GET /datafiles
  # GET /datafiles.json
  def index
  end
  
  def index_content
    @datafile = Datafile.new
    @userdetails = Userdetails.all.page params[:pagina_users]
    if verify_user 
		@datafiles = Datafile.any_of({:datatype.in => [".jpg",".JPG",".png",".gif",".jpeg",".PNG",".GIF",".JPEG"]}).where(username: session[:logged]).order("emailcount desc").page params[:pagina]
		@datafiles_docs = Datafile.any_of({:datatype.in => [".doc",".DOC",".docx",".DOCX"]}).where(username: session[:logged]).order("emailcount desc").page params[:pagina_doc]
		@datafiles_pdfs = Datafile.any_of({:datatype.in => [".pdf",".PDF"]}).where(username: session[:logged]).order("emailcount desc").page params[:pagina_pdf]
	else
		@datafiles = Datafile.any_of({:datatype.in => [".jpg",".JPG",".png",".gif",".jpeg",".PNG",".GIF",".JPEG"]}).order("emailcount desc").page params[:pagina]
		@datafiles_docs = Datafile.any_of({:datatype.in => [".doc",".DOC",".docx",".DOCX"]}).order("emailcount desc").page params[:pagina_doc]
		@datafiles_pdfs = Datafile.any_of({:datatype.in => [".pdf",".PDF"]}).order("emailcount desc").page params[:pagina_pdf]
	end
  end

  def sendmail
     if params[:emailid] =~ /^.*@.*\..*$/
       Datafiles.welcome_email(params[:emailid],params[:msg],params[:store_img]).deliver
       arr = params[:store_img].split("/")
       list_em= params[:emailid].split(",")
       Datafile.where(data: arr[arr.length-1]).add_to_set({ :emails => {"$each" => list_em }})
       @datafile_email=Datafile.where(data: "#{arr[arr.length-1]}").to_a
       Datafile.where(data: arr[arr.length-1]).update( :emailcount => @datafile_email.first.emails.length)
       redirect_to root_url, :notice => "Email successfully sent to #{params[:emailid]}"
     end   
  end
  
  def adminlogin
     if (params[:userid] == "admin")&&(params[:passwd] == "admin")  
       session[:logged]="<admin>"
       redirect_to root_url, :notice => "'ADMIN' logged-in successfully...."
     else
       if Userdetails.where( username: params[:userid], password: AESCrypt.encrypt(params[:passwd], "nyros123") ).exists?
          session[:logged]=params[:userid]
          redirect_to root_url, :notice => "'#{params[:userid].upcase}' logged-in successfully...."
       else
		  redirect_to root_url, :notice => "Invalid Username or Password"
	   end 
	 end
  end
  
  def adminlogout
    session[:logged] = nil
    redirect_to root_url, :notice => "Logged-out successfully...."
  end
  
  def update_user
    Userdetails.where(username: params[:uname]).update(:name => params[:nam], :password => AESCrypt.encrypt(params[:pwd], "nyros123"))
    redirect_to root_url
  end
  
  def delete_user
    Userdetails.where(username: params[:uname]).delete
    @data_delete= Datafile.all.where(username: params[:uname])
    @data_delete.each do |del|
    deleted=del.data
    if File.exists?("#{Rails.root}/public/uploads/#{deleted}")
	File.delete("#{Rails.root}/public/uploads/#{deleted}")
    end 
    end
    @data_delete.delete
    redirect_to root_url
  end
  
  def usersignup
    @userdetail = Userdetails.new(:username => params[:username] , :password => AESCrypt.encrypt(params[:password], "nyros123") , :name => params[:name] , :email => params[:email][0] )
    if @userdetail.save
		redirect_to root_url, :notice => "Account successfully created."
    else
        redirect_to root_url, :notice => "Error occured while creating user account."
    end
  end
  
  def pwd_decrpt
    @pwd= AESCrypt.decrypt(params[:pwd], "nyros123")
    render file: "/datafiles/pwd_decrpt.js.erb"
  end
  
  def usernamecheck
    if params[:username]!="admin"
    @create_user=true
	if Userdetails.exists?
    if Userdetails.where(username: params[:username]).exists?
		@create_user=false
    end
    end
    else
      @create_user=false
    end
    @cont="username"
    render partial: "check.html.erb"    
  end
  
  def emailnamecheck
    @create_user=true
	if Userdetails.exists?
    if Userdetails.where(email: params[:email]).exists?
		@create_user=false
    end
    end
    @cont="email"
    render partial: "check.html.erb"    
  end
  
  # POST /datafiles
  # POST /datafiles.json
  def create
  if params.has_key?(:datafile)
    uploaded_io = params[:datafile][:data]
    @datafile = Datafile.new(:data => uploaded_io.original_filename , :datatype => File.extname(uploaded_io.original_filename), :username => session[:logged] )
      if @datafile.save
        @datafiles = Datafile.all
        File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    	file.write(uploaded_io.read)
  	   end
      else
        render file: "/datafiles/error.js.erb"
      end
    
  else
	redirect_to new_datafile_path, :alert=> "Please Choose File"
  end
  end

  # DELETE /datafiles/1
  # DELETE /datafiles/1.json
  def destroy
    deleted=@datafile.data
    @datafile.destroy
    @datafiles = Datafile.any_of({:datatype.in => [".jpg",".JPG","png","gif","jpeg","PNG","GIF","JPEG"]}).page params[:pagina]
    @datafiles_docs = Datafile.any_of({:datatype.in => [".doc",".DOC",".docx",".DOCX"]}).page params[:pagina_doc]
    @datafiles_pdfs = Datafile.any_of({:datatype.in => [".pdf",".PDF"]}).page params[:pagina_pdf]
    if File.exists?("#{Rails.root}/public/uploads/#{deleted}")
	File.delete("#{Rails.root}/public/uploads/#{deleted}")
    end 
    respond_to do |format|
      format.js
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datafile
      @datafile = Datafile.find(params[:id])
    end
    
    def verify_user
       @userslist = Userdetails.all
       if @userslist.where( username: session[:logged] ).exists?
			return true
       else
			return false
       end
    end
    
    def verify_admin
       @userslist = Userdetails.all
       if @userslist.where( username: session[:logged] ).exists?
			return true
       else
			return false
       end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def datafile_params
      params.require(:datafile).permit(:data)
    end
end

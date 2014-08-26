module DatafilesHelper
  def admin_area(&block)
    content_tag(:div, class: 'admin', &block) if ((session[:logged]=="<admin>")||(UserDetails.where( username: session[:logged] ).exists?))
  end
end

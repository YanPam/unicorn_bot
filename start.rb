module Start
  def start!(*)
  	notify(:already_registered) && return if registered?

  	register
    notify(:success_registration)
  end

  private

  def register
    session[:id] = from['id']
  end
end

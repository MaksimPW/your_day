module UsersControllerHelper
  def sign_in_api user
    @user = user
    auth_headers = @user.create_new_auth_token
    request.headers.merge!(auth_headers)
  end
end
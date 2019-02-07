defmodule TodoApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :TodoApi,
  module: TodoApi.Guardian,
  error_handler: TodoApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

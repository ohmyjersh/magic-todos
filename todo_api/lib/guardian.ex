defmodule TodoApi.Guardian do
  use Guardian, otp_app: :todo_api

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    case TodoApi.Accounts.get_user!(claims["sub"]) do
    resource -> {:ok,  resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end

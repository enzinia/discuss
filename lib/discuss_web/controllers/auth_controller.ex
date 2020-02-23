defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Accounts

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    signin(conn, user_params)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, params) do
    case Accounts.get_or_create_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Auth error")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end

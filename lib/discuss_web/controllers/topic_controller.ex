defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Posts
  alias Discuss.Posts.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Posts.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Posts.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Posts.create_topic(conn.assigns.user, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Posts.get_topic!(id)
    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Posts.get_topic!(id)
    changeset = Posts.change_topic(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Posts.get_topic!(id)

    case Posts.update_topic(topic, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Posts.get_topic!(id)
    {:ok, _topic} = Posts.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Posts.get_topic(topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end

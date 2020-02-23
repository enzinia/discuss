defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.Posts

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Posts.get_topic_with_comments(topic_id)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    case Posts.create_comment_for(topic, user_id, %{content: content}) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, :error, socket}
    end
  end
end

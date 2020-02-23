defmodule Discuss.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Accounts.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Returns nil if no result was found.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def get_or_create_user(attrs \\ %{}) do
    changeset = User.changeset(%User{}, attrs)

    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end

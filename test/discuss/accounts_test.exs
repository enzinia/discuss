defmodule Discuss.AccountsTest do
  use Discuss.DataCase

  alias Discuss.Accounts

  describe "users" do
    alias Discuss.Accounts.User

    @valid_attrs %{email: "some email", provider: "some provider", token: "some token"}
    @update_attrs %{email: "some updated email", provider: "some updated provider", token: "some updated token"}
    @invalid_attrs %{email: nil, provider: nil, token: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.provider == "some provider"
      assert user.token == "some token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end

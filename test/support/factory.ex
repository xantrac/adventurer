defmodule Adventurer.Factory do
  use ExMachina.Ecto, repo: Adventurer.Repo

  def user_factory do
    %Adventurer.Accounts.User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      hashed_password: "password"
    }
    |> set_password("password")
  end

  def story_factory do
    %Adventurer.Stories.Story{
      title: Faker.Lorem.sentence(),
      description: Faker.Lorem.paragraph(),
      user: insert(:user),
      published_at: DateTime.utc_now()
    }
  end

  def node_factory do
    %Adventurer.Nodes.Node{
      title: Faker.Lorem.sentence(),
      body: %{
        id: "zbGZFPM-iI",
        type: "paragraph",
        data: %{
          text: "Some text"
        }
      }
    }
  end

  def generate_node_body(paragraphs_list) do
    blocks =
      Enum.map(paragraphs_list, fn paragraph ->
        %{
          id: "zbGZFPM-iI",
          type: "paragraph",
          data: %{
            text: paragraph
          }
        }
      end)

    %{
      time: 1_607_080_800_000,
      blocks: blocks,
      version: "2.8.1"
    }
  end

  def choice_factory do
    %Adventurer.Stories.Choice{
      description: Faker.Lorem.sentence()
    }
  end

  def choice_target_factory do
    %Adventurer.Stories.ChoiceTarget{}
  end

  def set_password(user, password) do
    user
    |> Adventurer.Accounts.User.registration_changeset(%{password: password})
    |> Ecto.Changeset.apply_changes()
  end
end

defmodule App.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :username, :string
      add :content, :string
      add :like_count, :integer
      add :repost_count, :integer

      timestamps()
    end
  end
end

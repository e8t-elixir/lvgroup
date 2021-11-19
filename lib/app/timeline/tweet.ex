defmodule App.Timeline.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :content, :string
    field :like_count, :integer, default: 0
    field :repost_count, :integer, default: 0
    field :username, :string, default: "dev"

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    # |> cast(attrs, [:username, :content, :like_count, :repost_count])
    # |> validate_required([:username, :content, :like_count, :repost_count])
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> validate_length(:content, min: 2, max: 140)
  end
end

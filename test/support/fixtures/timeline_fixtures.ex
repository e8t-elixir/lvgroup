defmodule App.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Timeline` context.
  """

  @doc """
  Generate a tweet.
  """
  def tweet_fixture(attrs \\ %{}) do
    {:ok, tweet} =
      attrs
      |> Enum.into(%{
        content: "some content",
        like_count: 42,
        retweet_count: 42,
        username: "some username"
      })
      |> App.Timeline.create_tweet()

    tweet
  end
end

defmodule App.TimelineTest do
  use App.DataCase

  alias App.Timeline

  describe "tweets" do
    alias App.Timeline.Tweet

    import App.TimelineFixtures

    @invalid_attrs %{content: nil, like_count: nil, retweet_count: nil, username: nil}

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Timeline.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Timeline.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      valid_attrs = %{content: "some content", like_count: 42, retweet_count: 42, username: "some username"}

      assert {:ok, %Tweet{} = tweet} = Timeline.create_tweet(valid_attrs)
      assert tweet.content == "some content"
      assert tweet.like_count == 42
      assert tweet.retweet_count == 42
      assert tweet.username == "some username"
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      update_attrs = %{content: "some updated content", like_count: 43, retweet_count: 43, username: "some updated username"}

      assert {:ok, %Tweet{} = tweet} = Timeline.update_tweet(tweet, update_attrs)
      assert tweet.content == "some updated content"
      assert tweet.like_count == 43
      assert tweet.retweet_count == 43
      assert tweet.username == "some updated username"
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_tweet(tweet, @invalid_attrs)
      assert tweet == Timeline.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Timeline.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Timeline.change_tweet(tweet)
    end
  end
end

defmodule App.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Timeline.Tweet

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets do
    # Repo.all(Tweet)
    Tweet |> order_by(desc: :inserted_at) |> Repo.all()
    # (from t in Tweet, order_by: [desc: t.id]) |> Repo.all()
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:tweet_created)
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
    |> broadcast(:tweet_updated)
  end

  def inc_like(%Tweet{id: id}) do
    # update_all 返回值第一个参数是修改行数，第二个是更新后的值。第二个默认为 nil，当query中有 select 才返回值 有的数据库不支持该操作
    {1, [tweet]} =
      from(t in Tweet, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [like_count: 1])

    broadcast({:ok, tweet}, :tweet_updated)
  end

  def inc_retweet(%Tweet{id: id}) do
    {1, [tweet]} =
      from(t in Tweet, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [retweet_count: 1])

    broadcast({:ok, tweet}, :tweet_updated)
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{data: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet, attrs \\ %{}) do
    Tweet.changeset(tweet, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(App.PubSub, "tweets")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, tweet}, event) do
    Phoenix.PubSub.broadcast(App.PubSub, "tweets", {event, tweet})
    {:ok, tweet}
  end
end

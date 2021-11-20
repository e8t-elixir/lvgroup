defmodule AppWeb.TweetLiveTest do
  use AppWeb.ConnCase

  import Phoenix.LiveViewTest
  import App.TimelineFixtures

  @create_attrs %{content: "some content", like_count: 42, retweet_count: 42, username: "some username"}
  @update_attrs %{content: "some updated content", like_count: 43, retweet_count: 43, username: "some updated username"}
  @invalid_attrs %{content: nil, like_count: nil, retweet_count: nil, username: nil}

  defp create_tweet(_) do
    tweet = tweet_fixture()
    %{tweet: tweet}
  end

  describe "Index" do
    setup [:create_tweet]

    test "lists all tweets", %{conn: conn, tweet: tweet} do
      {:ok, _index_live, html} = live(conn, Routes.tweet_index_path(conn, :index))

      assert html =~ "Listing Tweets"
      assert html =~ tweet.content
    end

    test "saves new tweet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.tweet_index_path(conn, :index))

      assert index_live |> element("a", "New Tweet") |> render_click() =~
               "New Tweet"

      assert_patch(index_live, Routes.tweet_index_path(conn, :new))

      assert index_live
             |> form("#tweet-form", tweet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tweet-form", tweet: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tweet_index_path(conn, :index))

      assert html =~ "Tweet created successfully"
      assert html =~ "some content"
    end

    test "updates tweet in listing", %{conn: conn, tweet: tweet} do
      {:ok, index_live, _html} = live(conn, Routes.tweet_index_path(conn, :index))

      assert index_live |> element("#tweet-#{tweet.id} a", "Edit") |> render_click() =~
               "Edit Tweet"

      assert_patch(index_live, Routes.tweet_index_path(conn, :edit, tweet))

      assert index_live
             |> form("#tweet-form", tweet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tweet-form", tweet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tweet_index_path(conn, :index))

      assert html =~ "Tweet updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes tweet in listing", %{conn: conn, tweet: tweet} do
      {:ok, index_live, _html} = live(conn, Routes.tweet_index_path(conn, :index))

      assert index_live |> element("#tweet-#{tweet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tweet-#{tweet.id}")
    end
  end

  describe "Show" do
    setup [:create_tweet]

    test "displays tweet", %{conn: conn, tweet: tweet} do
      {:ok, _show_live, html} = live(conn, Routes.tweet_show_path(conn, :show, tweet))

      assert html =~ "Show Tweet"
      assert html =~ tweet.content
    end

    test "updates tweet within modal", %{conn: conn, tweet: tweet} do
      {:ok, show_live, _html} = live(conn, Routes.tweet_show_path(conn, :show, tweet))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tweet"

      assert_patch(show_live, Routes.tweet_show_path(conn, :edit, tweet))

      assert show_live
             |> form("#tweet-form", tweet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tweet-form", tweet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tweet_show_path(conn, :show, tweet))

      assert html =~ "Tweet updated successfully"
      assert html =~ "some updated content"
    end
  end
end

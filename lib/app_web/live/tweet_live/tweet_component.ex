defmodule AppWeb.TweetLive.TweetComponent do
  use AppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"tweet-#{@tweet.id}"} class="tweet">
      <div class="row">
        <div class="column column-10">
          <div class="tweet-avatar"></div>
        </div>
        <div class="column column-90 tweet-body">
          <b>@<%= @tweet.username %></b>
          <br />
          <%= @tweet.content %>
        </div>
      </div>
      <div class="row">
        <div class="column tweet-button-column">
          <a href="#" phx-click="like" phx-value-name="phoenix" phx-target={@myself}>
            <i class="fas fa-heart"></i>
          </a> <%= @tweet.like_count %>
        </div>
        <div class="column tweet-button-column">
          <a href="#" phx-click="retweet" phx-target={@myself}>
            <i class="fas fa-retweet"></i>
          </a> <%= @tweet.retweet_count %>
        </div>
        <div class='column tweet-button-column'>
          <%= live_patch to: Routes.tweet_index_path(@socket, :edit, @tweet.id) do %><i class="fas fa-edit"></i><% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @tweet.id, data: [confirm: "Are you sure?"] do %><i class="fas fa-trash-alt"></i><% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", value, socket) do
    IO.inspect(value, label: "tweet_comp like")
    App.Timeline.inc_like(socket.assigns.tweet)
    {:noreply, socket}
  end

  def handle_event("retweet", _, socket) do
    App.Timeline.inc_retweet(socket.assigns.tweet)
    {:noreply, socket}
  end
end

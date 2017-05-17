defmodule Prbot.Slack do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  # Ping
  def handle_event(message = %{type: "message"}, slack, state) do
    if Regex.run ~r/<@#{slack.me.id}>:?\sping/, message.text do
      ping(message, slack)
    end

    if Regex.run ~r/<@#{slack.me.id}>:?\sreview/, message.text do
      review(message, slack)
    end

    {:ok, state}
  end

  def handle_event(_message, _slack, state) do
    {:ok, state}
  end

  def ping(message, slack) do
    IO.puts "ping"
    send_message("<@#{message.user}> pong", message.channel, slack)
    IO.puts "pong"
  end

  def review(message, slack) do
    IO.puts message.text
    send_message(":nerd_face:", message.channel, slack)
  end
end

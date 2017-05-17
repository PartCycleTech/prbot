defmodule Prbot.Slack do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message"}, slack, state) do
    IO.puts "handling message"
    if Regex.run ~r/<@#{slack.me.id}>:?\sping/, message.text do
      send_message("<@#{message.user} pong", message.channel, slack)
    end

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    IO.puts "handling unidentified message"
    {:ok, state}
  end
end

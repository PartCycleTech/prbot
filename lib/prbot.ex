defmodule Prbot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    unless Mix.env == :prod do
      Envy.auto_load
    end

    IO.puts "running"
    slack_token = System.get_env("SLACK_TOKEN")
    IO.puts slack_token

    children = [
      worker(Slack.Bot, [Prbot.Slack, [], slack_token])
    ]

    opts = [strategy: :one_for_one, name: Prbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

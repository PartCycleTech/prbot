defmodule Prbot do
  use Application

  def start(_type, _args) do
    IO.puts "running"
    children = [ Plug.Adapters.Cowboy.child_spec(:http, Prbot.Router, [], port: 4000) ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
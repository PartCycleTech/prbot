defmodule PrbotTest do
  use ExUnit.Case
  use Plug.Test

  doctest Prbot
  alias Prbot.Router

  @opts Router.init([])

  test "responds to greeting" do
    conn = conn(:get, "/webhook", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "hello"
  end
end

defmodule Prbot.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :prbot

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json, :urlencoded]
  plug :match
  plug :dispatch

  post "/webhook" do
    send_resp(conn, 200, "hello")
  end

  match _ do
    send_resp(conn, 404, "not_found")
  end
end

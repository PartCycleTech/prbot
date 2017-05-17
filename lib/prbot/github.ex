defmodule Prbot.Github do
  def client do
    Tentacat.Client.new(%{access_token: System.get_env("GITHUB_TOKEN")})
  end

  def getPRs do
    Tentacat.Pulls.list "PartCycleTech", "partcycle-backend", client
  end

end

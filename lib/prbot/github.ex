defmodule Prbot.Github do
  def client do
    Tentacat.Client.new(%{access_token: System.get_env("GITHUB_TOKEN")})
  end

  def getPRs do
    Tentacat.Pulls.list "PartCycleTech", "partcycle-backend", client
  end

  def getPRNumbers do
    for pr <- getPRs, do: pr["number"]
  end

  def getPRRefs do
    for pr <- getPRs, do: pr["head"]["ref"]
  end

  def getReviews(prNumber) do
    Tentacat.Pulls.Reviews.list "PartCycleTech", "partcycle-backend", prNumber, client
  end

  def getCombinedStatuses(ref) do
    response = Tentacat.Repositories.Statuses.find "PartCycleTech", "partcycle-backend", ref, client
    response["statuses"]
  end

  def getReviewsForAllPRs do
    for prNumber <- getPRNumbers, do: getReviews(prNumber)
  end

  def getCombinedStatusesForAllPRs do
    for ref <- getPRRefs, do: getCombinedStatuses(ref)
  end

  def getReviewsStates(reviews) do
    for review <- reviews, do: review["state"]
  end
end

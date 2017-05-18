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
    Tentacat.Pulls.Reviews.list "PartCycleTech", "prbot", prNumber, client
  end

  def getReviewRequests(prNumber) do
    Tentacat.Pulls.ReviewRequests.list "PartCycleTech", "partcycle-backend", prNumber, client
  end

  def getRequestedReviewers(prNumber) do
    for request <- getReviewRequests(prNumber), do: request["login"]
  end

  def getReviewsByUser(prNumber, username) do
    for review <- getReviews(prNumber), username == review["user"]["login"], do: review
  end

  def getLatestReviews(prNumber) do
    reviewsOldestFirst = Prbot.Github.getReviews(prNumber)
    reviewsNewestFirst = Enum.reverse(reviewsOldestFirst)
    Enum.uniq_by(reviewsNewestFirst, fn review -> review["user"]["login"] end)
  end

  def getStatusOfLatestReviews(prNumber) do
    # Each status is one of: "APPROVED", "COMMENTED", "CHANGES_REQUESTED"
    Enum.map(getLatestReviews(prNumber), fn(review) -> review["state"] end)
  end

  def getStatusOfPR(prNumber) do
    cond do
      Enum.all?(getStatusOfLatestReviews(prNumber), fn(status) -> status == "APPROVED" end) ->
        "APPROVED"
      Enum.any?(getStatusOfLatestReviews(prNumber), fn(status) -> status == "CHANGES_REQUESTED" end) ->
        "CHANGES_REQUESTED"
      Enum.any?(getStatusOfLatestReviews(prNumber), fn(status) -> status == "COMMENTED" end) ->
        "COMMENTED"
      true ->
        "PENDING"
    end
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

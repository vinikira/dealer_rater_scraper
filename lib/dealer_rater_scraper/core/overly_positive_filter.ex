defmodule DealerRaterScraper.Core.OverlyPositiveFilter do
  @moduledoc """
  Tries to infer **overly positive reviews** and returns
  the top 3 in order of severity.
  """

  alias DealerRaterScraper.Core.Review

  @high_review_rating 5.0
  @inconsistency_weight 0.166

  @doc """
  Looks for reviews that have higher `rating` and inconsistent `detailed_rating`.
  """
  @spec execute(list(Review.t())) :: list(Review.t())
  def execute(reviews) do
    reviews
    |> Enum.map(fn review ->
      {review, inconsistency_review_score(review)}
    end)
    |> Enum.filter(&(elem(&1, 1) != 0.0))
    |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
    |> Enum.take(3)
    |> Enum.map(&elem(&1, 0))
  end

  defp inconsistency_review_score(%Review{rating: rating, detailed_rating: detailed_rating}) do
    high_rating = rating >= @high_review_rating

    if high_rating do
      [
        detailed_rating.customer_service == 0.0,
        detailed_rating.quality_of_work == 0.0,
        detailed_rating.friendliness == 0.0,
        detailed_rating.pricing == 0.0,
        detailed_rating.overall_experience == 0.0,
        !detailed_rating.recommend_dealer
      ]
      |> Enum.reduce(0.0, fn
        true, score -> score + @inconsistency_weight
        false, score -> score
      end)
    else
      0.0
    end
  end
end

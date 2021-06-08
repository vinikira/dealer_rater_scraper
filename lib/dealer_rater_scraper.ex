defmodule DealerRaterScraper do
  @moduledoc """
  Provide some operations to work with `https://www.dealerrater.com/` review pages.
  """

  alias DealerRaterScraper.Core.OverlyPositiveFilter
  alias DealerRaterScraper.Core.Review

  require Logger

  @client Application.compile_env!(:dealer_rater_scraper, :client)
  @adapter Application.compile_env!(:dealer_rater_scraper, :adapter)

  @doc """
  Scrapes `pages` and tries to infer if there are invalid reviews for the given `slug`.
  """
  @spec scan_invalid_reviews(String.t(), integer()) :: :ok
  def scan_invalid_reviews(slug, pages \\ 5) when is_binary(slug) and is_integer(pages) do
    Logger.metadata(slug: slug)

    1..pages
    |> Task.async_stream(&scrap_page(slug, &1))
    |> Stream.filter(&filter_errors/1)
    |> Stream.flat_map(fn {:ok, result} -> result end)
    |> Enum.to_list()
    |> OverlyPositiveFilter.execute()
    |> Enum.each(&print_result/1)

    :ok
  end

  defp scrap_page(slug, page) do
    with {:ok, body} <- @client.get_reviews_by_slug(slug, page),
         {:ok, reviews} <- @adapter.parse(body) do
      reviews
    end
  end

  defp filter_errors({:ok, {:error, _} = error}), do: filter_errors(error)

  defp filter_errors({:error, error}) do
    Logger.error("An error occurred when scraping page: #{inspect(error)}")

    false
  end

  defp filter_errors(_), do: true

  defp print_result(%Review{} = review) do
    Logger.info(
      "The following review is suspected to be fake:\n\n#{inspect(review, pretty: true)}\n"
    )
  end
end

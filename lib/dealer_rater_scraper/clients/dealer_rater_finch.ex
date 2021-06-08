defmodule DealerRaterScraper.Clients.DealerRaterFinch do
  @behaviour DealerRaterScraper.Clients.DealerRaterClient

  alias Finch.Response

  @base_url Application.compile_env!(:dealer_rater_scraper, :base_url)

  @impl true
  @spec get_reviews_by_slug(String.t(), integer()) :: {:ok, binary()} | {:error, term()}
  def get_reviews_by_slug(slug, page \\ 1) do
    path = "/dealer/#{slug}/page#{page}/"

    request_result =
      :get
      |> Finch.build("#{@base_url}#{path}")
      |> Finch.request(DealerRaterFinch)

    case request_result do
      {:ok, %Response{body: body}} ->
        {:ok, body}

      {:error, _reason} = error ->
        error
    end
  end
end

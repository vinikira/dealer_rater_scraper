defmodule DealerRaterScraper.Clients.DealerRaterClient do
  @callback get_reviews_by_slug(String.t(), integer()) :: {:ok, binary()} | {:error, term()}
end

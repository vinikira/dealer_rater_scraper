defmodule DealerRaterScraper.Adapters.Adapter do
  alias DealerRaterScraper.Core.Review

  @callback parse(html_body :: String.t()) :: {:ok, list(Review.t())} | {:error, term()}
end

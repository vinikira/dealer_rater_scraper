import Config

config :dealer_rater_scraper, :client, DealerRaterScraper.Clients.DealerRaterFinch

config :dealer_rater_scraper, :adapter, DealerRaterScraper.Adapters.Floki

config :dealer_rater_scraper, :base_url, System.get_env("BASE_URL", "https://www.dealerrater.com")

config :logger, :console,
  metadata: [:slug],
  format: "$date [$level] $metadata $message\n"

import_config "#{Mix.env()}.exs"

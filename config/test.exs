import Config

config :dealer_rater_scraper, :client, DealerRaterScraper.Clients.MockDealerRaterClient

config :dealer_rater_scraper, :adapter, DealerRaterScraper.Adapters.MockAdapter

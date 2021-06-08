defmodule DealerRaterScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :dealer_rater_scraper,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DealerRaterScraper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.30.1"},
      {:finch, "0.7.0"},
      {:timex, "3.7.5"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end

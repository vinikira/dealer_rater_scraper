ExUnit.start()

Mox.defmock(DealerRaterScraper.Adapters.MockAdapter, for: DealerRaterScraper.Adapters.Adapter)

Mox.defmock(DealerRaterScraper.Clients.MockDealerRaterClient,
  for: DealerRaterScraper.Clients.DealerRaterClient
)

defmodule DealerRaterScraper.TestHelpers do
  alias DealerRaterScraper.Core.Review
  alias DealerRaterScraper.Core.Employee
  alias DealerRaterScraper.Core.DetailedRating

  def get_fixture(name) do
    File.read!("test/fixtures/#{name}")
  end

  def build(:review) do
    Review.new(
      user: "foo",
      title: "Fake title",
      contents: "Fake contents",
      rating: 5.0,
      date: ~N[2021-03-31 00:00:00],
      employees: [
        build(:employee, id: "1", name: "Kent Abernathy"),
        build(:employee, id: "2", name: "Taylor Prickett"),
        build(:employee, id: "3", name: "Dennis Smith")
      ],
      detailed_rating: build(:detailed_rating)
    )
  end

  def build(:employee) do
    Employee.new(id: "1", name: "Kent Abernathy", rating: 5.0)
  end

  def build(:detailed_rating) do
    DetailedRating.new(
      customer_service: 5.0,
      quality_of_work: 5.0,
      friendliness: 5.0,
      pricing: 5.0,
      overall_experience: 5.0,
      recommend_dealer: true
    )
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end
end

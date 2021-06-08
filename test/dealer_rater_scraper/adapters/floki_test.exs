defmodule DealerRaterScraper.Adapters.FlokiTest do
  use ExUnit.Case, async: true

  import DealerRaterScraper.TestHelpers

  alias DealerRaterScraper.Adapters.Floki, as: FlokiAdapter
  alias DealerRaterScraper.Core.Review
  alias DealerRaterScraper.Core.Employee
  alias DealerRaterScraper.Core.DetailedRating

  describe "parse/1" do
    test "should parse a valid review page" do
      html_body = get_fixture("valid_review_page.html")

      expected_review = [
        Review.new(
          user: "Stacie Mosley-Lynch",
          title: "\"Adrian was a great sales person. I drove in from Venus to...\"",
          contents:
            "Adrian was a great sales person. I drove in from Venus to get my oil changed and left with a brand new car. Thanks McKaig",
          rating: 4.8,
          date: ~N[2021-04-05 00:00:00],
          employees: [
            Employee.new(id: "273456", name: "Adrian \"AyyDee\" Cortes", rating: 5.0)
          ],
          detailed_rating:
            DetailedRating.new(
              customer_service: 5.0,
              quality_of_work: 4.0,
              friendliness: 5.0,
              pricing: 5.0,
              overall_experience: 5.0,
              recommend_dealer: true
            )
        ),
        Review.new(
          user: "Leon Word",
          title: "\"Lots of Knowledgeable, Friendly People. The person I...\"",
          contents:
            "Lots of Knowledgeable, Friendly People. The person I talked to, Dennis Smith, was very Knowledgeable and Taylor also. Very pleasurable experience!!
I would recommend anyone to check them out!!",
          rating: 5.0,
          date: ~N[2021-03-31 00:00:00],
          employees: [
            Employee.new(id: "2931", name: "Kent Abernathy", rating: 5.0),
            Employee.new(id: "640356", name: "Taylor Prickett", rating: 5.0),
            Employee.new(id: "507162", name: "Dennis Smith", rating: 5.0)
          ],
          detailed_rating:
            DetailedRating.new(
              customer_service: 5.0,
              quality_of_work: 5.0,
              friendliness: 5.0,
              pricing: 5.0,
              overall_experience: 5.0,
              recommend_dealer: true
            )
        )
      ]

      assert {:ok, expected_review} == FlokiAdapter.parse(html_body)
    end

    test "should not parse a review page with wrong dates" do
      html_body = get_fixture("invalid_review_page.html")

      expected = [
        {:error, :invalid_review_entry},
        {:error, :invalid_review_entry}
      ]

      assert {:ok, expected} == FlokiAdapter.parse(html_body)
    end
  end
end

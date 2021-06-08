defmodule DealerRaterScraperTest do
  use ExUnit.Case, async: true

  alias DealerRaterScraper.Adapters.MockAdapter
  alias DealerRaterScraper.Clients.MockDealerRaterClient

  import DealerRaterScraper.TestHelpers
  import ExUnit.CaptureLog
  import Mox

  setup :verify_on_exit!

  describe "scan_invalid_reviews/2" do
    test "Should print the top three." do
      scenario = [
        build(:review),
        build(:review,
          user: "first",
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              quality_of_work: 0.0,
              friendliness: 0.0,
              recommend_dealer: false
            )
        ),
        build(:review),
        build(:review,
          user: "second",
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              quality_of_work: 0.0,
              friendliness: 0.0,
              recommend_dealer: false
            )
        ),
        build(:review),
        build(:review,
          user: "third",
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              quality_of_work: 0.0,
              friendliness: 0.0,
              recommend_dealer: false
            )
        )
      ]

      slug = "fake-slug"
      html_body = "fake html"
      this = self()

      MockDealerRaterClient
      |> expect(:get_reviews_by_slug, 5, fn slug, page ->
        if page == 5 do
          send(this, slug)
        end

        {:ok, html_body}
      end)

      MockAdapter
      |> expect(:parse, 5, fn body ->
        send(this, body)

        {:ok, scenario}
      end)

      log = capture_log(fn -> DealerRaterScraper.scan_invalid_reviews(slug) end)

      assert_receive ^slug
      assert_receive ^html_body
      assert log =~ "user: \"first\""
      assert log =~ "user: \"second\""
      assert log =~ "user: \"third\""
      refute log =~ "user: \"foo\""
    end

    test "should fetch N pages if the PAGES is given" do
      pages = 2

      MockDealerRaterClient
      |> expect(:get_reviews_by_slug, pages, fn _slug, _page ->
        {:ok, "fake html body"}
      end)

      MockAdapter
      |> expect(:parse, pages, fn _body ->
        {:ok, []}
      end)

      assert :ok == DealerRaterScraper.scan_invalid_reviews("fake slug", pages)
    end

    test "should log if a page return an error during scraping" do
      error_message = "some error"

      MockDealerRaterClient
      |> expect(:get_reviews_by_slug, 1, fn _slug, _page ->
        {:error, error_message}
      end)

      log = capture_log(fn -> DealerRaterScraper.scan_invalid_reviews("fake slug", 1) end)

      assert log =~ "An error occurred when scraping page: #{inspect(error_message)}"
    end

    test "shouldn't log anything if there's no result" do
      MockDealerRaterClient
      |> expect(:get_reviews_by_slug, 5, fn _slug, _page ->
        {:ok, "fake html body"}
      end)

      MockAdapter
      |> expect(:parse, 5, fn _body ->
        {:ok, []}
      end)

      log = capture_log(fn -> DealerRaterScraper.scan_invalid_reviews("fake slug") end)

      assert log =~ ""
    end
  end
end

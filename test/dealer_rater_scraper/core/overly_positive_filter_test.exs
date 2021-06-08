defmodule DealerRaterScraper.Core.OverlyPositiveFilterTest do
  use ExUnit.Case, async: true

  alias DealerRaterScraper.Core.OverlyPositiveFilter

  import DealerRaterScraper.TestHelpers

  describe "execute/1" do
    test "should return the top three overly positive reviews" do
      expected_first =
        build(:review,
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              quality_of_work: 0.0,
              friendliness: 0.0,
              recommend_dealer: false
            )
        )

      expected_second =
        build(:review,
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              quality_of_work: 0.0,
              friendliness: 0.0
            )
        )

      expected_third =
        build(:review,
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              overall_experience: 0.0
            )
        )

      scenario = [
        build(:review),
        build(:review),
        expected_second,
        build(:review),
        expected_first,
        build(:review),
        expected_third
      ]

      assert [expected_first, expected_second, expected_third] ==
               OverlyPositiveFilter.execute(scenario)
    end

    test "should return an empty list if there's no inconsistency" do
      scenario = [
        build(:review),
        build(:review),
        build(:review),
        build(:review)
      ]

      assert [] == OverlyPositiveFilter.execute(scenario)
    end

    test "should return a list of size less than 3" do
      expected_unique =
        build(:review,
          rating: 5.0,
          detailed_rating:
            build(:detailed_rating,
              overall_experience: 0.0
            )
        )

      scenario = [
        build(:review),
        build(:review),
        expected_unique,
        build(:review),
        build(:review)
      ]

      assert [expected_unique] == OverlyPositiveFilter.execute(scenario)
    end
  end
end

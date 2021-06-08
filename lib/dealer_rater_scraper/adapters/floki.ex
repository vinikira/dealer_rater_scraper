defmodule DealerRaterScraper.Adapters.Floki do
  @behaviour DealerRaterScraper.Adapters.Adapter

  alias DealerRaterScraper.Core.Review
  alias DealerRaterScraper.Core.Employee
  alias DealerRaterScraper.Core.DetailedRating

  @date_format "{Mfull} {D}, {YYYY}"
  @reviews_selector ".review-entry"
  @rating_selector ".review-date > .dealership-rating > :first-child"
  @review_date_selector ".review-date > :first-child"
  @review_wrapper_selector ".review-wrapper > :first-child"
  @review_contents_selector ".review-content"
  @employee_rating_selector ".employee-rating-badge-sm > :first-child > span"
  @review_detailed_ratings_selector ".review-ratings-all > :first-child"
  @customer_service_selector ":nth-child(1) > :last-child"
  @quality_of_work_selector ":nth-child(2) > :last-child"
  @friendliness_selector ":nth-child(3) > :last-child"
  @pricing_selector ":nth-child(4) > :last-child"
  @overall_experience_selector ":nth-child(5) > :last-child"
  @recommend_dealer_selector ":nth-child(6) > :last-child"
  @recommend_yes "Yes"
  @recommend_no "No"

  @impl true
  @callback parse(html_body :: String.t()) :: {:ok, list(Review.t())} | {:error, term()}
  def parse(html_body) do
    with {:ok, document} <- Floki.parse_document(html_body) do
      reviews =
        document
        |> Floki.find(@reviews_selector)
        |> Enum.map(&parse_review/1)

      {:ok, reviews}
    end
  end

  defp parse_review(review_node) do
    case parse_date(review_node) do
      {:ok, date} ->
        {user, title} = parse_user_and_title(review_node)

        Review.new(
          user: user,
          title: title,
          contents: parse_contents(review_node),
          rating: parse_rating(review_node),
          date: date,
          employees: parse_employees(review_node),
          detailed_rating: parse_detailed_rating(review_node)
        )

      {:error, _reason} ->
        {:error, :invalid_review_entry}
    end
  end

  defp parse_user_and_title(review_node) do
    review_wrapper = Floki.find(review_node, @review_wrapper_selector)

    title =
      review_wrapper
      |> Floki.find("h3")
      |> Floki.text()

    user =
      review_wrapper
      |> Floki.find("span")
      |> Floki.text()
      |> String.replace("- ", "")

    {user, title}
  end

  defp parse_contents(review_node) do
    review_node
    |> Floki.find(@review_contents_selector)
    |> Floki.text()
  end

  defp parse_employees(review_node) do
    review_node
    |> Floki.find(".review-employee")
    |> Enum.map(&parse_employee/1)
  end

  defp parse_employee(review_employee) do
    name =
      review_employee
      |> Floki.find("a")
      |> Floki.text()
      |> String.trim()

    id =
      review_employee
      |> Floki.find("a")
      |> Floki.attribute("data-emp-id")
      |> List.first()

    rating =
      review_employee
      |> Floki.find(@employee_rating_selector)
      |> Floki.text()
      |> String.to_float()

    Employee.new(id: id, name: name, rating: rating)
  end

  defp parse_rating(review_node) do
    review_node
    |> Floki.find(@rating_selector)
    |> parse_rating_class()
  end

  defp parse_detailed_rating(review_node) do
    ratings_node = Floki.find(review_node, @review_detailed_ratings_selector)

    customer_service =
      ratings_node
      |> Floki.find(@customer_service_selector)
      |> parse_rating_class()

    quality_of_work =
      ratings_node
      |> Floki.find(@quality_of_work_selector)
      |> parse_rating_class()

    friendliness =
      ratings_node
      |> Floki.find(@friendliness_selector)
      |> parse_rating_class()

    pricing =
      ratings_node
      |> Floki.find(@pricing_selector)
      |> parse_rating_class()

    overall_experience =
      ratings_node
      |> Floki.find(@overall_experience_selector)
      |> parse_rating_class()

    recommend_dealer =
      ratings_node
      |> Floki.find(@recommend_dealer_selector)
      |> Floki.text()
      |> String.trim()
      |> parse_recommend_dealer()

    DetailedRating.new(
      customer_service: customer_service,
      quality_of_work: quality_of_work,
      friendliness: friendliness,
      pricing: pricing,
      overall_experience: overall_experience,
      recommend_dealer: recommend_dealer
    )
  end

  defp parse_recommend_dealer(@recommend_yes), do: true
  defp parse_recommend_dealer(@recommend_no), do: false

  defp parse_rating_class(node) do
    node
    |> Floki.attribute("class")
    |> List.first()
    |> String.replace(~r/[^0-9]/, "")
    |> String.split("", trim: true)
    |> Enum.join(".")
    |> String.to_float()
  end

  defp parse_date(review_node) do
    review_node
    |> Floki.find(@review_date_selector)
    |> Floki.text()
    |> Timex.parse(@date_format)
  end
end

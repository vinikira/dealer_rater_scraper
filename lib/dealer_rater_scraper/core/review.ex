defmodule DealerRaterScraper.Core.Review do
  alias DealerRaterScraper.Core.DetailedRating
  alias DealerRaterScraper.Core.Employee

  defstruct ~w[user title date rating detailed_rating contents employees]a

  @type t :: %__MODULE__{
          user: String.t(),
          title: String.t(),
          contents: String.t(),
          date: Date.t(),
          rating: float(),
          detailed_rating: DetailedRating.t(),
          employees: list(Employee.t())
        }

  @spec new(keyword()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end

defmodule DealerRaterScraper.Core.DetailedRating do
  defstruct ~w[customer_service quality_of_work friendliness pricing overall_experience recommend_dealer]a

  @type t :: %__MODULE__{
          customer_service: float(),
          quality_of_work: float(),
          friendliness: float(),
          pricing: float(),
          overall_experience: float(),
          recommend_dealer: boolean()
        }

  @spec new(keyword()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end

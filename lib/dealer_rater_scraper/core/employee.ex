defmodule DealerRaterScraper.Core.Employee do
  defstruct ~w[id name rating]a

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          rating: float()
        }

  @spec new(keyword()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end

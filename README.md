# DealerRaterScraper

Scraper for the reviews from [dealerrater.com](https://www.dealerrater.com/)
which tries to infer which of them are fake.
 
## Requirements
In order to run this project you'll need the following software
installed on your machine:

1. Elixir 1.12
2. Erlang 24.0

### Using ADSF
If you have [asdf.vm](https://asdf-vm.com) installed, just run in your
terminal:

``` shell
$ asdf install
```

## Getting Started

In order to start, run the following commands on your terminal:

``` shell
$ iex -S mix
```

And with the IEx session opened:
 
``` elixir
iex> DealerRaterScraper.scan_invalid_reviews("YOUR_SLUG") 

```

Where `YOUR_SLUG` is the slug of the chosen dealer, for example:

``` elixir
iex> my_slug = "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"
"McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"
iex> DealerRaterScraper.scan_invalid_reviews(my_slug) 
```

If you want, you can pass the number of pages to scrap as a second
parameter. By default it is 5.

``` elixir
iex> DealerRaterScraper.scan_invalid_reviews(my_slug, 3) 
```

If you want change the base URL, you can set the environment variable
`BASE_URL` before running, like this:

``` shell
$ BASE_URL='your custom url' iex -S mix
```

## Tests
In order to execute the tests, run in your terminal: 

``` shell
$ MIX_ENV=test mix test
```

## Inference method used
To infer which reviews are fake, the software scrapes the `N` pages
of review and makes the following checks:

1. Looking for reviews with a rating of 5.0;
2. Within those reviews, it checks the detailed rating, looking for
   any rating with a score of 0.0 (or `false` in the case of
   `recommend_dealer` field);
3. For each detailed rating in this condition, it sums
   `0.166`¹ to a score that measures the
   probability of that review is false;
4. Sorts by the highest score and takes three.

## Footnotes
¹: Is the division of 5.0 by 6 (quantity of detailed ratings).

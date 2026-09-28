library(tidyverse)

reviews <- read_csv("learners/data/Mobile Reviews Sentiment.csv")
# kommentar

reviews <- reviews |>
  mutate(price_local = str_extract(price_local, pattern ="\\d+\\.\\d+")) |> 
  mutate(price_local = as.numeric(price_local))
  

currencíes <- reviews |> 
  select(currency, price_local) |> 
  distinct(currency) |> 
  pull(currency)

rate <- c(5, 4.3, 8, 2.4, 1.3, 7, 6.8, 9
)

exr <- tibble(currency = currencíes, rate = rate)

reviews |> 
 left_join(exr) 





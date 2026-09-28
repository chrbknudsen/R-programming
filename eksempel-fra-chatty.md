---
title: "Temperaturer: list-columns, mapping og løkker"
output: html_document
---

::::::::::::::::::::::::::::::::::::::: objectives

- boilerplate

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- boilerplate

::::::::::::::::::::::::::::::::::::::::::::::::::


Dette eksempel viser et lille datasæt med 20 observationer. Temperaturen står i én kolonne, selv om værdierne bruger Celsius, Fahrenheit og Kelvin. Kolonnen `forhold` er en *list-column*: hver række rummer en vektor med et eller flere vejrforhold.

Pakker: `tibble`, `purrr` og `dplyr`.

## Opret datasættet


``` r
data <- tibble::tibble(
  id = 1:20,
  temperatur = c(
    "18 °C", "68 °F", "294 K", "12 °C", "59 °F",
    "281 K", "21 °C", "72 °F", "296 K", "7 °C",
    "50 °F", "278 K", "19 °C", "70 °F", "293 K",
    "15 °C", "64 °F", "285 K", "23 °C", "77 °F"
  ),
  sted = c(
    "Inde", "Inde", "Inde", "Ude", "Ude",
    "Ude", "Inde", "Inde", "Inde", "Ude",
    "Ude", "Ude", "Inde", "Inde", "Inde",
    "Ude", "Ude", "Ude", "Inde", "Inde"
  ),
  tidspunkt = rep(c("Morgen", "Middag", "Aften"), length.out = 20),
  forhold = strsplit(c(
    "tørt", "tørt,varmt", "fugtigt", "sol,blæst", "sol",
    "regn,blæst", "tørt", "varmt,tørt", "fugtigt", "overskyet",
    "sol,koldt", "regn", "tørt", "varmt", "fugtigt,varmt",
    "sol,blæst", "overskyet", "regn,koldt", "tørt,varmt", "tørt"
  ), ",")
)

data$forhold[[4]]  # To værdier i én celle: "sol" og "blæst"
```

``` output
[1] "sol"   "blæst"
```

## Map en funktion over list-column

`map_int()` tæller vejrforholdene i hver række. `map_lgl()` undersøger, om "regn" findes blandt dem.


``` r
data <- data |>
  dplyr::mutate(
    antal_forhold = purrr::map_int(forhold, length),
    regn = purrr::map_lgl(forhold, \(x) "regn" %in% x)
  )

data[c("id", "forhold", "antal_forhold", "regn")]
```

``` output
# A tibble: 20 × 4
      id forhold   antal_forhold regn 
   <int> <list>            <int> <lgl>
 1     1 <chr [1]>             1 FALSE
 2     2 <chr [2]>             2 FALSE
 3     3 <chr [1]>             1 FALSE
 4     4 <chr [2]>             2 FALSE
 5     5 <chr [1]>             1 FALSE
 6     6 <chr [2]>             2 TRUE 
 7     7 <chr [1]>             1 FALSE
 8     8 <chr [2]>             2 FALSE
 9     9 <chr [1]>             1 FALSE
10    10 <chr [1]>             1 FALSE
11    11 <chr [2]>             2 FALSE
12    12 <chr [1]>             1 TRUE 
13    13 <chr [1]>             1 FALSE
14    14 <chr [1]>             1 FALSE
15    15 <chr [2]>             2 FALSE
16    16 <chr [2]>             2 FALSE
17    17 <chr [1]>             1 FALSE
18    18 <chr [2]>             2 TRUE 
19    19 <chr [2]>             2 FALSE
20    20 <chr [1]>             1 FALSE
```

## While-løkke: omregn temperaturerne

`i` er rækkenummeret. Løkken fortsætter, så længe der er flere rækker. Vi trækker først tallet ud af teksten, undersøger enheden og gemmer resultatet i Celsius.


``` r
data$temperatur_c <- rep(NA_real_, nrow(data))

i <- 1
while (i <= nrow(data)) {
  tekst <- data$temperatur[i]
  tal <- as.numeric(sub(" .*", "", tekst))

  if (grepl("°C$", tekst)) {
    data$temperatur_c[i] <- tal
  } else if (grepl("°F$", tekst)) {
    data$temperatur_c[i] <- (tal - 32) * 5 / 9
  } else if (grepl("K$", tekst)) {
    data$temperatur_c[i] <- tal - 273.15
  } else {
    stop("Ukendt temperaturenhed: ", tekst)
  }

  i <- i + 1
}

data[c("temperatur", "temperatur_c")]
```

``` output
# A tibble: 20 × 2
   temperatur temperatur_c
   <chr>             <dbl>
 1 18 °C             18   
 2 68 °F             20   
 3 294 K             20.9 
 4 12 °C             12   
 5 59 °F             15   
 6 281 K              7.85
 7 21 °C             21   
 8 72 °F             22.2 
 9 296 K             22.9 
10 7 °C               7   
11 50 °F             10   
12 278 K              4.85
13 19 °C             19   
14 70 °F             21.1 
15 293 K             19.9 
16 15 °C             15   
17 64 °F             17.8 
18 285 K             11.9 
19 23 °C             23   
20 77 °F             25   
```

For eksempel bliver 68 °F til 20 °C, og 294 K bliver til 20,85 °C.

## For-løkke: beskriv vejrforholdene

Her gennemgår vi den samme list-column række for række og samler hvert sæt forhold til én tekst.


``` r
data$beskrivelse <- character(nrow(data))

for (i in seq_len(nrow(data))) {
  data$beskrivelse[i] <- paste(data$forhold[[i]], collapse = " og ")
}

data[c("id", "forhold", "beskrivelse")]
```

``` output
# A tibble: 20 × 3
      id forhold   beskrivelse     
   <int> <list>    <chr>           
 1     1 <chr [1]> tørt            
 2     2 <chr [2]> tørt og varmt   
 3     3 <chr [1]> fugtigt         
 4     4 <chr [2]> sol og blæst    
 5     5 <chr [1]> sol             
 6     6 <chr [2]> regn og blæst   
 7     7 <chr [1]> tørt            
 8     8 <chr [2]> varmt og tørt   
 9     9 <chr [1]> fugtigt         
10    10 <chr [1]> overskyet       
11    11 <chr [2]> sol og koldt    
12    12 <chr [1]> regn            
13    13 <chr [1]> tørt            
14    14 <chr [1]> varmt           
15    15 <chr [2]> fugtigt og varmt
16    16 <chr [2]> sol og blæst    
17    17 <chr [1]> overskyet       
18    18 <chr [2]> regn og koldt   
19    19 <chr [2]> tørt og varmt   
20    20 <chr [1]> tørt            
```

## `case_when()`: kategorisér temperaturerne

`case_when()` undersøger betingelserne i den viste rækkefølge og danner en ny kategorisk kolonne. Her betyder "Mildt" fra 10 °C til under 20 °C.


``` r
data <- data |>
  dplyr::mutate(
    temperaturkategori = dplyr::case_when(
      temperatur_c < 10 ~ "Koldt",
      temperatur_c < 20 ~ "Mildt",
      .default = "Varmt"
    )
  )

print(data, n = 20)
```

``` output
# A tibble: 20 × 10
      id temperatur sted  tidspunkt forhold   antal_forhold regn  temperatur_c
   <int> <chr>      <chr> <chr>     <list>            <int> <lgl>        <dbl>
 1     1 18 °C      Inde  Morgen    <chr [1]>             1 FALSE        18   
 2     2 68 °F      Inde  Middag    <chr [2]>             2 FALSE        20   
 3     3 294 K      Inde  Aften     <chr [1]>             1 FALSE        20.9 
 4     4 12 °C      Ude   Morgen    <chr [2]>             2 FALSE        12   
 5     5 59 °F      Ude   Middag    <chr [1]>             1 FALSE        15   
 6     6 281 K      Ude   Aften     <chr [2]>             2 TRUE          7.85
 7     7 21 °C      Inde  Morgen    <chr [1]>             1 FALSE        21   
 8     8 72 °F      Inde  Middag    <chr [2]>             2 FALSE        22.2 
 9     9 296 K      Inde  Aften     <chr [1]>             1 FALSE        22.9 
10    10 7 °C       Ude   Morgen    <chr [1]>             1 FALSE         7   
11    11 50 °F      Ude   Middag    <chr [2]>             2 FALSE        10   
12    12 278 K      Ude   Aften     <chr [1]>             1 TRUE          4.85
13    13 19 °C      Inde  Morgen    <chr [1]>             1 FALSE        19   
14    14 70 °F      Inde  Middag    <chr [1]>             1 FALSE        21.1 
15    15 293 K      Inde  Aften     <chr [2]>             2 FALSE        19.9 
16    16 15 °C      Ude   Morgen    <chr [2]>             2 FALSE        15   
17    17 64 °F      Ude   Middag    <chr [1]>             1 FALSE        17.8 
18    18 285 K      Ude   Aften     <chr [2]>             2 TRUE         11.9 
19    19 23 °C      Inde  Morgen    <chr [2]>             2 FALSE        23   
20    20 77 °F      Inde  Middag    <chr [1]>             1 FALSE        25   
# ℹ 2 more variables: beskrivelse <chr>, temperaturkategori <chr>
```


:::::::::::::::::::::::::::::::::::::::: keypoints

- Boilerplate

::::::::::::::::::::::::::::::::::::::::::::::::::

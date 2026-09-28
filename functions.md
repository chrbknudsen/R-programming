---
title: 'functions'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you write a lesson using R Markdown and `{sandpaper}`?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Explain how to use markdown with the new lesson template
- Demonstrate how to include pieces of code, figures, and nested challenge blocks

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

Hvad er en funktion overhovedet, og hvorfor laver vi dem?

Hvordan laver man en funktion?


``` r
my_first_function <- function(input){
   mean(input, na.rm = TRUE)
}
```


## A useful function

på denne side kan vi downloade data om markedsandele for mobilfabrikanter i Afrika.

Den tillader os at downloade data direkte eksempelvis i en 
read_csv

https://gs.statcounter.com/vendor-market-share/mobile/africa/chart.php?device=Mobile&device_hidden=mobile&statType_hidden=vendor&region_hidden=af&granularity=yearly&statType=Device%20Vendor&region=Africa&fromInt=2022&toInt=2025&fromYear=2022&toYear=2025&csv=1

Den kan vi doktorere på, og når frem til at dette er nok til at få 
data for africa: 


``` r
library(tidyverse)
"https://gs.statcounter.com/vendor-market-share/mobile/chart.php?device=Mobile&device_hidden=mobile&statType_hidden=vendor&region_hidden=af&granularity=yearly&statType=Device%20Vendor&fromInt=2022&toInt=2025&fromYear=2022&toYear=2025&csv=1" |> str_replace("af", "EU")
```


:::: callout
## How did we find that?

We found the site INDSÆT URL. Right-clicking on download and copying the url we got the url above. 

Inspecting the url reveal that 
::::

"https://gs.statcounter.com/vendor-market-share/mobile/chart.php?device=Mobile&device_hidden=mobile&statType_hidden=vendor&region_hidden=af&granularity=yearly&statType=Device%20Vendor&fromInt=2022&toInt=2025&fromYear=2022&toYear=2025&csv=1"

Det betyder at vi "blot" skal ændre "region_hidden=af" til "region_hidden=eu" for at få data fra europa.

Det kan vi gøre med en søg og erstat.

Og så en spoiler (eller en discussion med solution - minimeret i hvert fald.)

:::: spoiler
## Will this always work?

Det her går kun godt for der ikke står "af" andre steder i urlen. Det lidt mere robuste ville være:

paste0("https://gs.statcounter.com/vendor-market-share/mobile/chart.php?device=Mobile&device_hidden=mobile&statType_hidden=vendor&region_hidden=", input, "&granularity=yearly&statType=Device%20Vendor&fromInt=2022&toInt=2025&fromYear=2022&toYear=2025&csv=1")

hvor vi konkatenerer to dele af urlen, på hver side af det vi så ændrer.

::::


## selve funktionen:


``` r
grabs_data <- function(region){
   url <- "https://gs.statcounter.com/vendor-market-share/mobile/chart.php?device=Mobile&device_hidden=mobile&statType_hidden=vendor&region_hidden=af&granularity=yearly&statType=Device%20Vendor&fromInt=2022&toInt=2025&fromYear=2022&toYear=2025&csv=1"
   url <- str_replace(url, "af", region)
   read_csv(url) |> 
      mutate(region = region, .after = 1)
}
```

Den spytter nu en data frame ud, som indeholder data for den region vi har valgt. 

Vi gemmer funktionen i en separat .R fil. Og kører source på den.


``` r
source("scripts/grabs_data.R")
```

## hvilke regioner har vi så?

afrika: af
europa: eu
nordamerika: na
sydamerika:  sa
asien: as
oceanien: oc

Det kan vi skrive som en vektor.


``` r
regions <- c("af", "sa", "na", "eu", "as", "oc")
```

Så vi vil gerne have skrevet en funktion der kan indsætte det her
på "af" pladsen i vores url. Hvordan gør vi det?

## en for-løkke

Vi vil gerne trække data for hver af de regioner vi har i regions.

Så for hver region i `regions`, vil vi gerne køre grabs_data(navnetpåregionen)

Det kan vi gøre manuelt. Vi kan også bede R gøre det. Og det gør vi i en for-løkke.


``` r
for(region in regions){
   grabs_data(region)
}
```

For-løkken løber gennem hvert enkelt element i `regions`, et efter et. Hvert af dem sættes efter tur til `region` og
i løkken kører vi så funktionen `grabs_data` på det element i `regions` vi er nået til. 

Men det er en god ide at gemme resultatet i et eller andet. Ellers får vi blot spyttet output ud på konsollen. Og vi ville gerne kunne arbejde med det bagefter.

## Hvordan gemmer vi det?

vores funktion spytter dataframes ud. Vi forventer at få 6 styk i alt. 
Så når vi gemmer dem, skal vi have dem samlet i et objekt eller datastruktur, der
kan indeholde flere dataframes. Den type datastruktur vi har i R der kan samle hvad som helst op er en liste.

Ja, der findes i princippet andre, men ikke indbygget i R.

Så vi definerer en liste. Og for hver iteration i vores for løkke, gemmer vi resultatet i 
Så vi definerer en liste, gemmer resultatet for hvert kald af grabs_data i listen.




``` r
resultat <- list()
for(region in regions){
   print(region)
   resultat[[region]] <- grabs_data(region)

}
```

Nu har vi så en liste, `resultat`, der indeholder 6 dataframes. Dem vil vi gerne have samlet til en.

Det sker så ofte, at der findes en funktion til det: `bind_rows()`


``` r
resultat |> bind_rows() 
```

Vi skal nok gå lidt ind i hvad en liste er. Det er en del af formålet.


## Så hvad er en liste?

Vectors have a major limitation. They can only contain elements of the same type. And they cant contain dataframes.

If we need to construct an object that can contain elements of more than one type of data, we use a `list`.

We already know lists! A dataframe is a list of vectors (of the same length).


``` r
my_first_list <- list(mtcars, "text", c(1:3))
```

my_first_list now contains a dataframe, at text-string and a numeric vector with three elements.

We extract elements from lists in a slightly different way. If we have a vector, `vector[2]` will extract the second element. If it is a
numeric vector, we get a numeric element, a character vector will return a character.

`my_first_list[2]` will return a list-element, that is, not the "raw" element:


``` r
my_first_list[2]
```

``` output
[[1]]
[1] "text"
```

Note the [[1]] at the beginning. This is a hint that what is actually returned is a list:


``` r
class(my_first_list[1])
```

``` output
[1] "list"
```

If we want to get the actual element, in this case a string/character, we need to use a [[]] notation:


``` r
my_first_list[[2]]
```

``` output
[1] "text"
```

This also mean that if we want to add a fourth element to the list, we have to use the [[]] notation:


``` r
my_first_list[[4]] <- c(TRUE, FALSE, FALSE, TRUE)
```


::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::


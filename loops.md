---
title: 'loops'
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

Udvidet R-programmeringskursus 

Hvilket datasæt skal vi bruge? 

Kurset skal være slides-baseret 

Starte hvor vi slap på sidste kursus og bygge videre ovenpå det 

 


Funktioner (recycling - men jeg ved ikke om det er så vigtigt) 

recyling eksempel:


``` r
1:4 + 1:2
```

``` output
[1] 2 4 4 6
```

1:2 er kortere end 1:4. Så det kan man jo ikke.  Men vi kan recycle 1:2.

Vi kan ikke recycle hvis længderne ikke går op i hinanden:


``` r
1:3 + 1:4
```

``` warning
Warning in 1:3 + 1:4: longer object length is not a multiple of shorter object
length
```

``` output
[1] 2 4 6 5
```

Eller - det kan vi, men det kaster en advarsel, og skal nok gøre med forsigtighed.

Tage reviews og lave sentiment analyse 

For hvert enkelt review 

For hvert enkelt source 

Data-strukturer 

Matricer 
Den kan vi godt få svært ved at finde en måde at introducere...

Lister 
der er noget allerede

Christian har en ide med mapping af funktion på datasæt  

Case when 

til omkodning af data


``` r
mutate(ny_kol = case_when(
   x < 5 ~ "mindre end fem",
   x == 5 ~ "lig fem",
   x > 5 ~ "større end fem",
   .default = "godt spørgsmål"
))

NA_character_
```

Måske NA_character_ introduceret her - eller har de opdateret case_when til at håndtere det?

Samle lande i regioner 

Fx source 

Fx lave alder om til aldersgruppe 

If_else 

Hvis original sprog er eng ikke oversat eller oversat 

Flere scripts 

Funktioner.R 

Libraries.R 

Selvescriptet.R 

Coersing af data 

‘Age’ lav om til streng og ikke tal, så der skal coerses 

Text 

Sentiment analyse 

Join 

Vendor med andet datasæt 

Faktorer 

kategoriske variable. Har vi ordinale værdier i datasættet?

forcats

Vendor navn 

Pivot 

Vendor datasæt skal pivoteres 

Matricer 

Hvis man vil videre med statistik 

Chi i anden test 

Plot? 

Lave noget med ordinale faktorer 

Loops – while, for 

Tildeling af kategorier på baggrund af ord i review – kategorier som liste 

Finde de 10 første positive for hvert brand 

Hente filer med data fra vendor – samle i en list – bind_rows 

Logiske strukturer 

Ideer til sammenhænge 

Funktioner – en med case-when og loop (læg i seperat script) 

Script med packages/library kommandoer bruges med source i andre filer 

Function(text){if_else(text, str_detect(“julefilm”, “ja”, “nej”} - måske i description feltet 

::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::


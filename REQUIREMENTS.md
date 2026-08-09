# Requirements

Tested with:

```
R version 4.5.3 (2026-03-11)
```

## Required packages

| Package | Version tested | Used for |
|---|---|---|
| Lahman | 14.0.0 | Baseball database (Fielding, Batting, People, HallOfFame, AwardsPlayers, AllstarFull) |
| tidyverse | 2.0.0 | Data wrangling and plotting (dplyr, ggplot2, etc.) |
| FactoMineR | 2.16 | Principal component analysis |
| factoextra | 2.2.0 | PCA visualization (scree plot, contributions, cos2) |
| plotly | 4.12.0 | Interactive Hall of Fame cluster plots |
| rmarkdown | 2.31 | Rendering `CapstoneAnalysis.Rmd` |
| knitr | 1.51 | Rendering `CapstoneAnalysis.Rmd` |

Install everything with:

```r
install.packages(c(
  "Lahman", "tidyverse", "FactoMineR", "factoextra", "plotly",
  "rmarkdown", "knitr"
))
```

## Optional

`pdftools` (3.9.0) was used one time to rasterize `Capstone Presentation.pdf` into the images stored in
`presentation_slides/`. Those images are already checked into this repo, so `pdftools` is **not** required
to knit `CapstoneAnalysis.Rmd` — only if you want to regenerate the slide images from a new version of the
source PDF:

```r
install.packages("pdftools")
```

## Rendering

A working [Pandoc](https://pandoc.org/) installation is required to knit to HTML (RStudio bundles its own,
so no separate install is needed if you're using RStudio).

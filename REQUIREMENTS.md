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
| plotly | 4.12.0 | Interactive Hall of Fame cluster plots (main report only) |
| broom | 1.0.13 | Tidy model-output tables (regression coefficients) |
| kableExtra | 1.4.0 | Styled HTML tables (striped/hover, wrapped long-text columns) |
| rmarkdown | 2.31 | Rendering `CapstoneAnalysis.Rmd` and `CapstonePresentationSlides.Rmd` |
| knitr | 1.51 | Rendering `CapstoneAnalysis.Rmd` and `CapstonePresentationSlides.Rmd` |

Install everything with:

```r
install.packages(c(
  "Lahman", "tidyverse", "FactoMineR", "factoextra", "plotly",
  "broom", "kableExtra", "rmarkdown", "knitr"
))
```

## Rendering

A working [Pandoc](https://pandoc.org/) installation is required to knit to HTML (RStudio bundles its own,
so no separate install is needed if you're using RStudio).

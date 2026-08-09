# Baseball Capstone Analysis

Statistical analysis of the [Lahman baseball database](https://cran.r-project.org/package=Lahman) exploring three questions:

1. **Fielding errors** — Are certain positions more error-prone than others? (logistic regression)
2. **Workhorse players** — What predicts whether a position player logs 80+ games in a season? (PCA)
3. **Hall of Fame archetypes** — Do All-Star appearances and Gold Gloves cluster Hall of Famers into recognizable groups? (K-Means & hierarchical clustering)

Originally written for the PDAT620 Data Science Capstone (Feb 2020); refreshed in 2026 with interactive
`plotly` visualizations and re-verified against a current snapshot of the Lahman package.

**Read the full write-up:** https://rpubs.com/datadataguy13/1451741

**View the slide deck:** _add the slides RPubs link here after publishing `CapstonePresentationSlides.Rmd`_

## Repository contents

| File | Description |
|---|---|
| `CapstoneAnalysis.Rmd` | The complete analysis — narrative + code + plots, knits to the published HTML report |
| `CapstonePresentationSlides.Rmd` | Click-through slide deck (ioslides) built from the original presentation, published separately |
| `FieldingCapstoneModels.R` | Standalone script: fielding error logistic regression |
| `WorkHorseAnalysis.R` | Standalone script: workhorse PCA analysis |
| `HallOfFameClustering.R` | Standalone script: Hall of Fame K-Means/hierarchical clustering |
| `presentation_slides/` | Slide images (rasterized from the original deck), used by `CapstonePresentationSlides.Rmd` |
| `slide_style.css` | Minimal styling for the slide deck |
| `REQUIREMENTS.md` | R version and package versions needed to reproduce the analysis |

## Reproducing this analysis

1. Install R and the packages listed in [`REQUIREMENTS.md`](REQUIREMENTS.md).
2. Open `CapstoneAnalysis.Rmd` in RStudio.
3. Click **Knit** to render the full HTML report.
4. (Optional) Click **Publish** to push it to RPubs or another destination.

The three standalone `.R` scripts contain the original, section-by-section exploratory code; `CapstoneAnalysis.Rmd`
is the cleaned-up, combined, and documented version used for the published report.

## Data source

All data comes from the `Lahman` R package (Friendly, Dalzell, Monkman, Murphy, Foot, & Zaki-Azat), which
packages Sean Lahman's public domain baseball database. Cross-referenced against
[Baseball Reference](https://www.baseball-reference.com/) for validation.

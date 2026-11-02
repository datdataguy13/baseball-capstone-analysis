# Baseball Capstone Analysis

Statistical analysis of the [Lahman baseball database](https://cran.r-project.org/package=Lahman) exploring three questions:

1. **Fielding errors** — Are certain positions more error-prone than others? (logistic regression)
2. **Workhorse players** — Which stats go hand-in-hand with a position player logging 80+ games in a season? (PCA)
3. **Hall of Fame archetypes** — Do All-Star appearances and Gold Gloves cluster Hall of Famers into recognizable groups? (K-Means & hierarchical clustering)

Originally written for the PDAT620 Data Science Capstone (Feb 2020); refreshed in 2026 with interactive
`plotly` visualizations and re-verified against a current snapshot of the Lahman package.

**Skills demonstrated:** logistic regression with test-set evaluation (confusion matrix, sensitivity/
specificity, AUC), principal component analysis, K-Means and hierarchical clustering with silhouette-based
cluster validation, hypothesis testing (chi-squared), data wrangling across six relational tables, and
interactive visualization with `plotly`.

**Read the full write-up:**
- Posit Connect Cloud: https://datdataguy13-data-science-and-analytical-storytelling-capstone.share.connect.posit.cloud/
- GitHub Pages mirror: https://datdataguy13.github.io/baseball-capstone-analysis/ (report), plus [`/slides.html`](https://datdataguy13.github.io/baseball-capstone-analysis/slides.html) for the deck

The report is published to both. GitHub Pages is built automatically by the
[`publish-pages`](.github/workflows/publish-pages.yml) workflow, which re-knits
`CapstoneAnalysis.Rmd` and `CapstonePresentationSlides.Rmd` on every push to
`main` and deploys the self-contained HTML — nothing rendered is committed to the
repo. Run `Rscript render-site.R` to reproduce the same site locally.

## Repository contents

| File | Description |
|---|---|
| `CapstoneAnalysis.Rmd` | The complete analysis — narrative + code + plots, knits to the published HTML report |
| `CapstonePresentationSlides.Rmd` | Click-through slide deck (ioslides) rebuilt from the original presentation's text and charts, published separately |
| `FieldingCapstoneModels.R` | Standalone script: fielding error logistic regression |
| `WorkHorseAnalysis.R` | Standalone script: workhorse PCA analysis |
| `HallOfFameClustering.R` | Standalone script: Hall of Fame K-Means/hierarchical clustering |
| `220px-Herman_Long_Baseball.jpg`, `GregMaddux.jpg` | Photos used in the slide deck |
| `REQUIREMENTS.md` | R version and package versions needed to reproduce the analysis |

The slide deck re-derives its charts live from the Lahman data (same code as the main report, condensed)
rather than embedding static screenshots of the original PowerPoint — it has no external file
dependencies once knitted, so it publishes reliably to RPubs.

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

# Renders the capstone report and the slide deck into a self-contained static
# site under _site/, for GitHub Pages. Both outputs are self_contained HTML
# (images embedded as data URIs), so the two .html files are the only artifacts
# the site needs -- no _files/ sidecar directories to deploy.
#
# This is an *additional* publishing path; it does not touch the Posit Connect
# deployment. Run it locally with `Rscript render-site.R` or let the GitHub
# Actions workflow run it on every push to main.

site_dir <- "_site"
dir.create(site_dir, showWarnings = FALSE)

# Main analysis report -> the site landing page
rmarkdown::render(
  "CapstoneAnalysis.Rmd",
  output_file = "index.html",
  output_dir  = site_dir
)

# Presentation deck -> /slides.html
rmarkdown::render(
  "CapstonePresentationSlides.Rmd",
  output_file = "slides.html",
  output_dir  = site_dir
)

message("Rendered site into ", normalizePath(site_dir))

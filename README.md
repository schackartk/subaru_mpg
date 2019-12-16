# subaru_mpg
## Data
This is an R script for the TidyTuesday Project, and is my first attempt at a TidyTuesday.

The data were fetched from the [TidyTuesday Github Repo](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-10-15)

The data include highway and city fuel efficiency of many car makes and models over several years as reported by the US EPA.
## Inspiration
As this was my first try, I drew inspiration heavily from the [blogpost](https://thebioengineer.github.io/thebioengineer.github.io/2019/09/10/big-mtcars/) by Ellis Hughes linked in the README.md of the data.

## Rationale
I decided to focus in on Subaru data, and anyone who knows me will understand why. I wanted to show how the fuel efficiency of various models has changed over time.

One of the biggest judgement calls was how to reorganize the model names.

Many of the models have submodels, such as when the Outback was first released as a Subaru Legacy Outback Wagon. Then, there is the Outback XT, etc.

Sometimes, it seems like the same model was even just entered in differently from year to year.

So, I used regular expressions to find commonalities in names to collapse down the number of models and make the plots more readable. In doing so, I lost some information, but this is a frequent tradeoff.

## Presentation
I began by making an interactive plot, but since I intended to post this to various social media, I made the final output a static plot saved as a .png.

## Acknowledgements
Thank you to the [R for Data Science Community](https://twitter.com/R4DScommunity) for the great community of data science.
Thank you to [@APonsero](https://twitter.com/APonsero) for introducing me to the R4DS community, and inspiring me to join the tidyverse.

## Authorship
Kenneth Schackart

* Twitter: [\@SchackartK](https://twitter.com/SchackartK)
* Github:  [schackartk](https://github.com/schackartk)

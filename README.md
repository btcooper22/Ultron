# Ultron
App to randomly generate Marvel film drinking rules

# Usage

Clone this repository into the location of your choice, then run the Shiny app `Ultron/app.R`. Select your randomisation parameters and hit the button!

# How does it work?

For each film, specific drinking rules are found in `definitions/films.csv`, where "film" is the specific film, "rule" is a given rule, 
and "class" gives the size of drink that goes with the rule. Rules that can apply to **multiple** films are found in `definitions/pool.csv`. Here, for each rule, the "requires" column
indicates the flag that must be active for the film in order for that rule to be active. Finally, `definitions/vars.csv` is a matrix of which flags are active (**Y**) or inactive (**N**)
for each film. When the randomise button is pressed, the app chooses a film, filters all available rules for that film, and selects as many rules from each class as specified.

# Further notes

The flags in `definitions/vars.csv` may not be 100% complete and accurate. I went through them in my head, and therefore they may be conservative. For example, the PORTAL flag only
contains films which I'm absolutely sure contain portal stuff. I encourage people to inform me of any missing or incorrect flags, as well as suggesting additional rules!

curl -o log.html -# "http://stats.espncricinfo.com/ci/engine/records/averages/batting.html?class=2;current=2;id=6;type=team"
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' #all player data just after scrapping
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | sed -n -e '/Bumrah/,/<\/tr>/p' #individual player data just after scrapping
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | sed -n -e '/Bumrah/,/<\/tr>/p' | head -n 5 | tail -n 1 #used for each player individual bating column extraction.Need to initialise a number mapping
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | grep '<a' | awk '{print $5 " " $6}' | sed 's/class="data-link">//g' | sed 's/<\/a><\/td>//g' | wc -l #used for loop count
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | grep '<a' | awk '{print $5 " " $6}' | sed 's/class="data-link">//g' | sed 's/<\/a><\/td>//g' #Player Name list

#8th column is average of a player
cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | sed -n -e '/Bumrah/,/<\/tr>/p' | head -n 8 | tail -n 1 | sed 's/<td nowrap="nowrap">//g' | sed 's/<\/td>//g' #batting average of each palyer found by name


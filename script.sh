#/bin/sh

rm -f log.html database.db players_list.tmp

echo "Datafetch Starting."

curl -o log.html -# "http://stats.espncricinfo.com/ci/engine/records/averages/batting.html?class=2;current=2;id=6;type=team"

echo "Datafetch Completed."

no_of_player=$(cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | grep '<a' | awk '{print $5 " " $6}' | sed 's/class="data-link">//g' | sed 's/<\/a><\/td>//g' | wc -l )

touch database.db players_list.tmp

cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | grep '<a' | awk '{print $5 " " $6}' | sed 's/class="data-link">//g' | sed 's/<\/a><\/td>//g' > players_list.tmp

while IFS= read -r line; do
    avg_record_cmd="cat log.html | sed -n -e '/<tbody>/,/<\/tbody>/p' | grep -A 17 '<tr' | sed -n -e '/$line/,/<\/tr>/p' | head -n 8 | tail -n 1 | sed 's/<td nowrap=\"nowrap\">//g' | sed 's/<\/td>//g' | sed 's/<td class=\"padDp2\" nowrap=\"nowrap\">-/NA/g'"
    players_average=$(eval $avg_record_cmd)
    # echo $players_average
    echo $line" | "$players_average >> database.db
done < players_list.tmp

echo "CURRENT INDIAN PLAYER AND BATTING AVERAGES."

echo "########################################################################"

echo "PLAYER NAME | BATTING AVERAGE"
cat database.db

echo "########################################################################"

rm players_list.tmp

while true
do
	echo "Press [1] to SEARCH."
    echo "Press [2] to UPDATE."
    echo "Press [3] to ADD."
    echo "Press [4] to DELETE."
    echo "Press [Ctrl + C] to exit."

    read var

    case $var in
        1)
            #SEARCH
            
        ;;
        2)
            #UPDATE

        ;;
        3)
            #ADD

        ;;
        4)
            #DELETE

        ;;
        *)
            echo "Please Enter valid key."
        ;;
    esac

done
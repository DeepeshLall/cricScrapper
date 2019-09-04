#/bin/sh

rm -f log.html database.db players_list.tmp updated_database.db

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
    echo $line" |"$players_average >> database.db
done < players_list.tmp

echo "CURRENT INDIAN PLAYER AND BATTING AVERAGES."

echo "########################################################################"

echo "PLAYER NAME | BATTING AVERAGE"
cat database.db

rm players_list.tmp

while true
do
    echo "########################################################################"
    echo "OPTIONS"
	echo "Press [1] to SEARCH."
    echo "Press [2] to UPDATE."
    echo "Press [3] to ADD."
    echo "Press [4] to DELETE."
    echo "Press [5] to view Database."
    echo "Press [Ctrl + C] to exit."

    read var

    case $var in
        1)
            #SEARCH
            echo "Enter The player name to be searched."
            read player_name
            correct_player_name=$(grep "$player_name" database.db | cut -d '|' -f 1)

            if [ "$correct_player_name" != "$player_name " ];
            then
                echo "Player Not found in database."
            else
                echo "Batting Average of $player_name"
                grep "$player_name" database.db | cut -d '|' -f 2
            fi
        ;;
        2)
            #UPDATE
            echo "Enter The player name whose details is to be updated."
            read player_name

            correct_player_name=$(grep "$player_name" database.db | cut -d '|' -f 1)

            if [ "$correct_player_name" != "$player_name " ];
            then
                echo "Player Not found in database."
            else

                echo "Player Details:"
                grep "$player_name" database.db

                while true
                do
                    echo "Press [1] to update name or Press [2] to update Batting average OR Press [3] to go back to selection menu."
                    read var2

                    case $var2 in
                        1) 
                            echo "Please give the updated name:"
                            read update_name
                            sed s/"$player_name"/"$update_name"/g database.db > database.tmp
                            rm database.db
                            mv database.tmp database.db
                            echo "Database updated Successfully."
                            break
                        ;;
                        2)
                            echo "Please give the updated Batting average:"
                            read update_score
                            player_score=$(grep "$player_name" database.db | cut -d '|' -f 2)
                            sed s/"$player_name |$player_score"/"$player_name | $update_score"/g database.db > database.tmp
                            rm database.db
                            mv database.tmp database.db
                            echo "$player_name | $update_score"
                            echo "Database updated Successfully."
                            break
                        ;;
                        3)
                            break
                        ;;
                        *)
                            echo "Enter a valid key"
                        ;;
                    esac
                done
            fi
        ;;
        3)
            #ADD
            echo "Enter player name to be added."
            read player_name

            correct_player_name=$(grep "$player_name" database.db | cut -d '|' -f 1)

            if [ "$correct_player_name" == "$player_name " ];
            then
                echo "Player already found in database please update or try different name."
            else
                echo "Enter $player_name's Batting average"
                read batting_avg

                echo "$player_name | $batting_avg" >> database.db
                echo "Added player's detail to database."
            fi
        ;;
        4)
            #DELETE
            echo "Enter the player name to be removed from Database."
            read player_name

            correct_player_name=$(grep "$player_name" database.db | cut -d '|' -f 1)

            if [ "$correct_player_name" != "$player_name " ];
            then
                echo "Player Not found in database."
            else

                sed "/$player_name/d" database.db > database.tmp
                rm database.db
                mv database.tmp database.db
                echo "Player removed from the database successfully."
            fi
        ;;
        5)
            cat database.db
        ;;
        *)
            echo "Please Enter valid key."
        ;;
    esac

done
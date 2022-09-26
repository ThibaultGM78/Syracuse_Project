#!/bin/bash
help(){
    echo -e "\nUsage : syracuse.bash [OPTION] [FIRST U0] [LAST U0]\n\nCalculate the flights of the Syracuse sequences with U0 between the two values ​​input. \n\nDisplays four graphs that represent: max altitude, flight time, altitude time in terms of U0 and all the sequences Un in terms of n on the same graph.\n
All graphs and a text file that contains maximum, minimum and average of this datas are saved in a results directory.\n\nOPTIONS :\n\n-h                           display help
"
}


re='^[0-9]+$' #for check if something is a number
cd "$(dirname "$0")" #we place it in the directory that contains syracuse.bash (first argument of script = $0)

if  [[ $1 = -h ]]; then
   help
   exit 1
fi

if  [[ $# -ne 2 ]]; then #checks if we have two arguments
   help
   exit 1
fi

if  ! [[ $1 =~ $re ]] || ! [[ $2 =~ $re ]]; then #checks if the arguments are numbers
    help
    exit 1
fi

if  [ $1 -eq 0 ] || [ $2 -eq 0 ] || [ $1 -gt $2 ]; then #checks if the arguments are different from 0 and if min<=max
    help
    exit 1
fi

if  [ -e ./tmp ]; then 
    echo -e "\nYou have a directory named tmp, to work the program needs to remove them \ny/n (n:stop program)\n" #because we'll creat directory with this name
    rm -I -R ./tmp
fi

if  [ -e ./tmp ]; then exit; fi

if  [ -e ./results ]; then
    echo -e "\nYou have a directory named result, to work the program needs to remove them \ny/n (n:stop program)\n"
    rm -I -R ./results
fi

if  [ -e ./results ]; then exit; fi

min=$1
max=$2

mkdir ./tmp #this directory will remove in end
mkdir ./results

cd ./tmp

touch plot.dat
gcc ../syracuse.c -o syracuse

for (( i=$min; i <= $max; i++ )); do

	./syracuse $i  f$i.dat #creation of f***.dat files

    eval `tail -3 f${i}.dat`; #gets values after '=' if variable with appoint before '=' (variable's name=value)
    echo "${i} ${altimax} ${dureevol} ${dureealtitude}" >> plot.dat #fill plot.dat line by line

done






title=("altitude maximum atteinte" "Duree de vol" "Duree de vol en altitude")


for i in 0 1 2; do

    gnuplot -p << END_GNUPLOT

    set terminal jpeg    
	set output "${title[$i]}.jpeg"
	set title  "${title[$i]} en fonction de U0"
    set xlabel "U0"
    set ylabel "${title[$i]}"
	plot 'plot.dat' u 1:$(($i+2)) w l notitle #notitle= without title
    
END_GNUPLOT
done


gnuplot -p << END_GNUPLOT
    
    set terminal jpeg
    set output "Un en fonction de n.jpeg"
    set xlabel "n"
    set ylabel "Un"
    set title "Un en fonction de n pour tous les U0 dans [$min; $max]"
    plot for [i = $min:$max] "f".i.".dat" u 1:2 w l lt rgb "purple" notitle #represents the contents of all file appoint f***.dat

END_GNUPLOT



for f in *\ *; do mv "$f" "${f// /_}"; done #change the spaces on '_' in name of file
mv *.jpeg ../results 







cd ../results

#merges the four images in one image
convert Un_en_fonction_de_n.jpeg Duree_de_vol.jpeg +append 1.jpeg #merges two images horizontally
convert altitude_maximum_atteinte.jpeg  Duree_de_vol_en_altitude.jpeg +append 2.jpeg 
convert  1.jpeg 2.jpeg -append Merged_result.jpeg #merges two images vertically
rm 1.jpeg 2.jpeg

eog Merged_result.jpeg & #display image

###################################################################### Bonus ############################################################################################

cd ../tmp

touch ../results/synthese-$min-$max.txt

echo "              MAX MIN AVERAGE" >> ../results/synthese-$min-$max.txt

echo -n "altimax       " >> ../results/synthese-$min-$max.txt
sort -n -k 2 ./plot.dat | awk '{SUM+=$2; if ( NR == 1) MIN=$2}  END{print SUM/NR, MIN, $2}' >> ../results/synthese-$min-$max.txt #gets min, max and average of a plot.dat
echo -n "dureevol      " >> ../results/synthese-$min-$max.txt
sort -n -k 3 ./plot.dat | awk '{SUM+=$3; if ( NR == 1) MIN=$3}  END{print SUM/NR, MIN, $3}' >> ../results/synthese-$min-$max.txt
echo -n "dureealtitude " >> ../results/synthese-$min-$max.txt
sort -n -k 4 ./plot.dat | awk '{SUM+=$4; if ( NR == 1) MIN=$4}  END{print SUM/NR, MIN, $4}' >> ../results/synthese-$min-$max.txt


cd ../
rm -r ./tmp



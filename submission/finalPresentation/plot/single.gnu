set terminal png size 800,500 enhanced font "Helvetica,14"
set output 'output.png'

red = "#990000"; green = "#00FF00"; blue = "#000099"; skyblue = "#87CEEB";
green1 = "#006600";
set yrange [65:90]
set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set xtics format ""
set grid ytics
set ylabel "Accuracy [%]"

#set title "Single-View"
plot "bar.dat" using 2:xtic(1) title "base" linecolor rgb red, \
            '' using 3 title "CNN+biLSTM" linecolor rgb blue, \
            '' using 4 title "Alex+LSTM" linecolor rgb green, \
            '' using 5 title "Alex+biLSTM" linecolor rgb green1 

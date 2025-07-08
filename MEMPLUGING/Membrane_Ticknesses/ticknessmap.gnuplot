set size ratio 1 1,1
#hacer un mapa de calor
set pm3d map
#graficar 3D
#set pm3d at b
#set style line 100 lt 5 lw 0.5
#set pm3d depthorder border lc 'black' lw 1
set pm3d interpolate 20,20 flush begin noftriangles nohidden3d corners2color mean
set title 'thickness map'
set xlabel "GridX (Å)"
set xrange [-50:50]
set yrange [-50:50]
set cbrange [0:-4]
#set cbtics 0, -0.5
#set autoscale
set ylabel "GridY (Å)"
set palette defined ( 0 "blue", 1 "cyan", 2 "green", 3 "yellow", 4 "red" )
set cblabel "DDthickness Map"
splot 'DDthicknessmap_matrix.dat' u 1:2:3 title ""
pause mouse
set term postscript portrait enhanced color "Times-Roman" 20
set out "DDthickness_map_gnuplot_normalizado.eps"
replot

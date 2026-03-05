To get octave results for major revision of ETRE-D-25-00149 
run:

cd Fig_src/OctaveCode/DCloads
./bin/go.sh

cd Fig_src/OctaveCode/ACloads
./bin/go.sh


To copy octave results files csv to:
../../pgfplots/results/

cat listofcsv.txt | xargs -I {} cp -vf {} ../../pgfplots/results/

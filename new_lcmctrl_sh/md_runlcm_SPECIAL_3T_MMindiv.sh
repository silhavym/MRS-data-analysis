# runlcm: 	run lcm
#    		create .CONTROL file for lcm, run and display output ps
# 		do ECC 
# Code obtained from Matthew Taylor
# altered by Jamie Near on Jan 27 2009
# currently the documentation is not entirely correct
# check the actual script for what it does
# 
#
# $1 directory within scratch, up to and including subject number (ie N10_01/N10_01_001) 
# $2 scan ID:  (ie. special_front, special_rear);
# $3 'lcm'
#
WORKING_DIR=${1} #ie. N10_01/N10_01_001/special_front
echo $WORKING_DIR
datadir="/data/near/studies/${WORKING_DIR}/"
outdir="/data/near/studies/${WORKING_DIR}/lcm-out"
water_dir=/data/near/studies/${WORKING_DIR}_w/
mkdir -p ${outdir}
series="main${2}_lcm"
waterseries="${2}w_lcm"
te='8.5'
# scans in (datadir)/{scan number}/{series}.fid
# varian2raw at ~/.lcmodel/varian/varian2raw
# creates controlfile in scan directory
# uses basis file in ~/basisfiles/
# creates results in (outdir)/te{te}/
#
# --------------
# --------------
if test -d $WATER_DIR; then
ECC=1
echo Applying eddy current correction and water scaling
fi 

# generate the lcm .CONTROL file
controlfile="$outdir/${series}.control"
echo " \$LCMODL" > $controlfile
echo " OWNER='Jamie Near, Douglas CIC, McGill University'" >> $controlfile
echo " KEY=210387309" >> $controlfile
echo " TITLE= '${scanid} special ${series}'" >> $controlfile
echo " FILRAW= '$datadir/${series}'" >> $controlfile
echo " FILPS='$outdir/${series}.ps'" >> $controlfile
echo " FILTAB='$outdir/${series}.table'" >> $controlfile
#echo " ATTH2O=0.9" >> $controlfile
# gray matter subject1
#echo " WCONC=5.8820e+04" >> $controlfile
# white matter subject1
#echo " WCONC=3.8692e+04" >> $controlfile
echo " HZPPPM=123.24" >> $controlfile
echo " DELTAT=.00025" >> $controlfile
echo " dorefs(1)=F" >> $controlfile
echo " NUNFIL=4096" >> $controlfile
echo " lps=8" >> $controlfile
echo " ltable= 7" >> $controlfile
echo " FILBAS='${HOME}/.lcmodel/basis-sets/matlabBasis/Masoumeh_BS/md_SPECIAL_3T_Mac.basis'" >> $controlfile
echo " ppmst= 4.2" >> $controlfile
echo " ppmend= 0.2" >> $controlfile
if [ ${ECC} == 1 ]; then
echo doing water scaling
echo " DOECC= T" >> $controlfile
echo " DOWS= T" >> $controlfile
echo " FILH2O='${water_dir}/${waterseries}'" >> $controlfile
fi
echo " neach = 999" >> $controlfile
echo " nuse1= 2 " >> $controlfile
echo " chuse1(1)='NAA'" >> $controlfile
echo " chuse1(2)='PCr'" >> $controlfile
echo " nomit=1" >> $controlfile
echo " chomit(1)='Cit'" >> $controlfile
#echo " chomit(1)='MM1'" >> $controlfile
#echo " chomit(1)='MM2'" >> $controlfile
#echo " chomit(3)='MM3'" >> $controlfile
#echo " chomit(4)='MM4'" >> $controlfile
#echo " chomit(5)='MM5'" >> $controlfile
#echo " chomit(6)='MM6'" >> $controlfile
#echo " chomit(7)='MM7'" >> $controlfile
#echo " chomit(8)='MM8'" >> $controlfile
#echo " chomit(9)='MM9'" >> $controlfile
echo " NRATIO= 9" >> $controlfile
echo " CHRATO(1)='MM1/Cr+PCr = 1.3200  +- 0.0793'" >> $controlfile
echo " CHRATO(2)='MM2/MM1 = 0.2859  +- 0.0110'" >> $controlfile
echo " CHRATO(3)='MM3/MM1 = 1.1245  +- 0.1664'" >> $controlfile
echo " CHRATO(4)='MM4/MM1 = 1.0994  +- 0.1294'" >> $controlfile
echo " CHRATO(5)='MM5/MM1 = 2.4920  +- 0.2165'" >> $controlfile
echo " CHRATO(6)='MM6/MM1 = 1.4599  +- 0.5108'" >> $controlfile
echo " CHRATO(7)='MM7/MM1 = 0.8138  +- 0.0919'" >> $controlfile
echo " CHRATO(8)='MM8/MM1 = 0.2042  +- 0.0210'" >> $controlfile
echo " CHRATO(9)='MM9/MM1 = 1.9250  +- 0.3854'" >> $controlfile
echo " NSIMUL = 0" >> $controlfile
echo " LCSV=11" >> $controlfile
echo " LCOORD = 9" >> $controlfile
echo " FILCOO='$outdir/${series}.coord'" >> $controlfile
echo " FILCSV='$outdir/${series}.csv'" >> $controlfile
echo " VITRO=F" >> $controlfile
echo " DKNTMN = 0.40" >> $controlfile
echo " \$END" >> $controlfile
chmod 'u+x' $controlfile
echo "running LCmodel"

# -----------
# run LCmodel
~/.lcmodel/bin/lcmodel < $controlfile
echo "LCmodel complete"

# display result

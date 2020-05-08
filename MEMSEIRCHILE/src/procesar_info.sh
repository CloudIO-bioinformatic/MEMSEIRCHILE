#!/bin/bash
#casos confirmados, poblacion por region y por comuna
git -C /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/ pull
datafile=$(ls  /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto2|sort|tail  -n 2|head -n 1);
echo $datafile;
tail -n +2 /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto2/$datafile|awk 'BEGIN{OFS=FS=","}{region=$1;gsub(" ","_",region);print region"\t"$3"\t"$5"\t"$6}'|sort -k1 > info/datos_casos_confirmados.info;
tail -n +2 /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto2/$datafile|awk 'BEGIN{OFS=FS=","}{region=$1;gsub(" ","_",region);print region}'|sort|uniq > info/regiones.info; 
tail -n +2 /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto2/$datafile|awk 'BEGIN{OFS=FS=","}{comuna=$3;gsub(" ","_",comuna);print comuna}'|sort|uniq > info/comunas.info;
#regiones
IFS=$'\n';for line in $(cat info/regiones.info);do grep "^$line" info/datos_casos_confirmados.info > info/$line.region;done
#comunas
for line in $(cat info/comunas.info);do echo $line;awk 'BEGIN{OFS=FS="\t"}($2=="'$line'"){print $0}' info/datos_casos_confirmados.info > info/$line.comuna; done
#fallecidos por region
datafile2=$(ls  /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto4|sort|tail -n 2|head -n 1);
echo $datafile2;
tail -n +2 /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto4/$datafile2|awk 'BEGIN{OFS=FS=","}{region=$1;gsub("  ","_",region);print region"\t"$5}'|head -n 16|sort -k1 > info/fallecidos_por_region.info;
#casos severos o criticos
awk 'BEGIN{OFS=FS=","}{region=$1;gsub(" ","_",region);print region"\t"$NF}' /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto8/UCI.csv|tail -n +2|sort -k1>info/casos_severos.info;
#calcular cantidad de comunas por region
awk 'BEGIN{OFS=FS="\t"}{print $1}' info/datos_casos_confirmados.info |uniq -c|awk '{print $2"\t"$1}'|sort -k1 > info/comunas_por_region.info
#obtener d por region
paste info/casos_severos.info info/fallecidos_por_region.info |awk 'BEGIN{OFS=FS="\t"}{print $1,$2+$4}' > info/d_por_region.info
#obtener d por cantidad de comunas por region
paste info/d_por_region.info info/comunas_por_region.info |awk 'BEGIN{OFS=FS="\t"}{print $3,$2/$4}' > info/d_por_comunas_de_region.info
#Recuperadas por comuna
awk 'BEGIN{OFS=FS=","}{$NF="0";$(NF-1)="0";$(NF-2)="0";print $0}' /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto15/FechaInicioSintomas.csv |tail -n +2|sort -k1|awk 'BEGIN{OFS=FS=","}{suma=0;for(i=6; i<NF-2; ++i) {printf "%d\t",$i;suma+=$i;};comuna=$3;gsub(" ","_",comuna);print comuna"\t"suma;}'|awk 'BEGIN{OFS=FS="\t"}{print $(NF-1),$NF}' > info/Recuperados_por_comuna.info
#Luego se debe juntar toda la informacion en 2 archivos, la información de las comunas y de las regiones por separado, para luego ser procesada por R.
for region in $(cat info/d_por_comunas_de_region.info|awk '{print $1}');do d=$(grep "$region" info/d_por_comunas_de_region.info|awk '{print $2}');awk 'BEGIN{OFS=FS="\t"}($1=="'$region'"){print $0,"'$d'"}' info/datos_casos_confirmados.info;done > ready/datos_comunas.almost
#Como estan ordenados los datos por region, se hace un paste para tener los datos necesarios para R
paste ready/datos_comunas.almost info/Recuperados_por_comuna.info |awk 'BEGIN{OFS=FS="\t"}{print $1,$2,$3,$4,$5,$7}'> ready/datos_comuna.ready
rm ready/datos_comunas.almost
#agregamos las tasas de emigracion por comuna
for region in $(cat ../data/tasas_emigracion_censo2017.info|awk '{print $1}');do tasa=$(grep "$region" ../data/tasas_emigracion_censo2017.info|awk '{print $2}');awk 'BEGIN{OFS=FS="\t"}($1=="'$region'"){print $0,"'$tasa'"}' ready/datos_comuna.ready;done > ready/datos_comunas.ready
rm ready/datos_comuna.ready
#datos para calcular R0
#awk 'BEGIN{OFS=FS=","}{print $4"\t"$5"\t"$8}' /home/cquevedo/SEIR/SEIR.v1/data/Datos-COVID19/output/producto5/TotalesNacionales_T.csv |tail -n +2 |head > ready/datos_R0.ready





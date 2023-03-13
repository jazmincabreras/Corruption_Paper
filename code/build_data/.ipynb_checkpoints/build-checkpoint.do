/********************************************************************************
			PROYECTO CORRUPCIÓN
********************************************************************************/

clear all
cls

set maxvar 15000

if "`c(username)'" == "dell" global main "C:\Users\dell\Documents\QLAB\Corruption_Paper"

if "`c(username)'" == "Usuario" global main "C:\Users\Usuario\Desktop\QLAB\GitHub\Corruption_Paper"

global input "$main\input"
global data "$main\output\data_build"
global extra "$main\extra"
global varnames "$main\extra\varnames"
global iecodebook "$main\extra\iecodebook"


*==================================
* CREAR LAGGED VARIABLES PARA SIAF 
*==================================

use $input\matrix_siaf, clear

sort ubigeo year

foreach var of varlist _all {
    gen _`var' = `var'[_n-1]
}

save $input\matrix_siaf_l, replace

*==========================================================================
* BASE CONTRALORIA: CONSTRUCCIÓN DE CUATRO CASOS DE VARIABLES DEPENDIENTES
*==========================================================================

* (1) contraloría del año inicial del reporte por ubigeo y año
*--------------------------------------------------------------

use $input\contraloria_caso, clear

rename año_inicio year
collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year tipo_control)
/*  variables: 11
observaciones: 701  */
***********************
duplicates list ubigeo year
*45 obs duplicadas -> convertimos a todas en sepi
*keep ubigeo year tipo_control
*export excel using "C:\Users\Usuario\Downloads\aaaa.xls", firstrow(variables)
*keep ubigeo year
*duplicates tag, generate(dup)
*list if dup==1
*codebook dup
gen dup = 0 
replace dup = 1 in 12
replace dup = 1 in 44
replace dup = 1 in 63
replace dup = 1 in 65
replace dup = 1 in 88
replace dup = 1 in 138
replace dup = 1 in 146
replace dup = 1 in 171
replace dup = 1 in 177
replace dup = 1 in 180
replace dup = 1 in 183
replace dup = 1 in 200
replace dup = 1 in 282
replace dup = 1 in 285
replace dup = 1 in 294
replace dup = 1 in 298
replace dup = 1 in 355
replace dup = 1 in 365
replace dup = 1 in 382
replace dup = 1 in 390
replace dup = 1 in 398
replace dup = 1 in 410
replace dup = 1 in 413
replace dup = 1 in 417
replace dup = 1 in 426
replace dup = 1 in 432
replace dup = 1 in 438
replace dup = 1 in 440
replace dup = 1 in 467
replace dup = 1 in 490
replace dup = 1 in 495
replace dup = 1 in 497
replace dup = 1 in 500
replace dup = 1 in 515
replace dup = 1 in 520
replace dup = 1 in 524
replace dup = 1 in 528
replace dup = 1 in 530
replace dup = 1 in 533
replace dup = 1 in 539
replace dup = 1 in 571
replace dup = 1 in 619
replace dup = 1 in 656
replace dup = 1 in 689
replace dup = 1 in 692
drop if dup>0

order ubigeo year penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "CORRUPCIÓN INTENSA"
replace corrup_intensa = 0 if corrup_intensa == 1
replace corrup_intensa = 1 if corrup_intensa == 2
label define frec1 1 "Sí" 0 "No"
label list frec1
label values corrup_intensa frec1
codebook corrup_intensa

* variable "corrupción amplia"
gen corrup_amplia = 1 if civil != 0
replace corrup_amplia = 1 if penal != 0
replace corrup_amplia = 0 if corrup_amplia == .
tostring corrup_amplia, gen(str_corrup_amplia) force
encode str_corrup_amplia, gen(id_corrup_amplia)
drop corrup_amplia str_corrup_amplia
rename id_corrup_amplia corrup_amplia
label var corrup_amplia "CORRUPCIÓN AMPLIA"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio
label var monto_ "SUMA DE MONTOS: AUDITADO Y OBJETO"

* variable interactiva: monto auditado según prueba
gen monto = monto_auditado if tipo_control == 1
replace monto = monto_objeto_servicio if tipo_control == 2
label var monto "MONTO AUDITADO SEGÚN PRUEBA"

* variables interactivas: número de personas según tipo de corrupción
gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
label var per_corrup1 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN INTENSA"
label var per_corrup2 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN AMPLIA"

* variables interactivas monto según tipo de corrupción
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia
label var monto_corrup1 "MONTO SEGÚN CORRUPCIÓN INTENSA"
label var monto_corrup2 "MONTO SEGÚN CORRUPCIÓN AMPLIA"

save $data/c1, replace
/*  variables: 19
observaciones: 657  */


* (2) contraloría del año inicial del reporte por ubigeo, caso y año
*--------------------------------------------------------------------

use $input\contraloria_caso, clear
rename año_inicio year
/*  variables: 12
observaciones: 849  */

drop titulo_asunto objetivo entidad_auditada año_emision unidad_emite año_fin

order ubigeo year doc_name tipo_control penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "CORRUPCIÓN INTENSA"
replace corrup_intensa = 0 if corrup_intensa == 1
replace corrup_intensa = 1 if corrup_intensa == 2
label define frec1 1 "Sí" 0 "No"
label list frec1
label values corrup_intensa frec1
codebook corrup_intensa

* variable "corrupción amplia"
gen corrup_amplia = 1 if civil != 0
replace corrup_amplia = 1 if penal != 0
replace corrup_amplia = 0 if corrup_amplia == .
tostring corrup_amplia, gen(str_corrup_amplia) force
encode str_corrup_amplia, gen(id_corrup_amplia)
drop corrup_amplia str_corrup_amplia
rename id_corrup_amplia corrup_amplia
label var corrup_amplia "CORRUPCIÓN AMPLIA"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio
label var monto_ "SUMA DE MONTOS: AUDITADO Y OBJETO"

* variable interactiva: monto auditado según prueba
gen monto = monto_auditado if tipo_control == 1
replace monto = monto_objeto_servicio if tipo_control == 2
label var monto "MONTO AUDITADO SEGÚN PRUEBA"

* variables interactivas: número de personas según tipo de corrupción
gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
label var per_corrup1 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN INTENSA"
label var per_corrup2 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN AMPLIA"

* variables interactivas monto según tipo de corrupción
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia
label var monto_corrup1 "MONTO SEGÚN CORRUPCIÓN INTENSA"
label var monto_corrup2 "MONTO SEGÚN CORRUPCIÓN AMPLIA"

save $data/c2, replace
/*  variables: 20
observaciones: 849  */


* (3) contraloría panel por ubigeo y año
*----------------------------------------

use $input\contraloria_panel, clear
rename año year
collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year tipo_control)
/*  variables: 11
observaciones: 1446  */
***********************
duplicates list ubigeo year
*149 obs duplicadas -> convertimos a todas en sepi
*keep ubigeo year tipo_control
*export excel using "C:\Users\Usuario\Downloads\bbbb.xls", firstrow(variables)
*keep ubigeo year
*duplicates tag, generate(dup)
*list if dup==1
*codebook dup
gen dup = 0 
replace dup = 1 in 24
replace dup = 1 in 58
replace dup = 1 in 83
replace dup = 1 in 85
replace dup = 1 in 87
replace dup = 1 in 125
replace dup = 1 in 127
replace dup = 1 in 129
replace dup = 1 in 131
replace dup = 1 in 133
replace dup = 1 in 135
replace dup = 1 in 164
replace dup = 1 in 172
replace dup = 1 in 174
replace dup = 1 in 176
replace dup = 1 in 235
replace dup = 1 in 245
replace dup = 1 in 247
replace dup = 1 in 300
replace dup = 1 in 302
replace dup = 1 in 304
replace dup = 1 in 318
replace dup = 1 in 320
replace dup = 1 in 322
replace dup = 1 in 330
replace dup = 1 in 373
replace dup = 1 in 381
replace dup = 1 in 383
replace dup = 1 in 387
replace dup = 1 in 389
replace dup = 1 in 391
replace dup = 1 in 393
replace dup = 1 in 406
replace dup = 1 in 414
replace dup = 1 in 422
replace dup = 1 in 424
replace dup = 1 in 428
replace dup = 1 in 430
replace dup = 1 in 478
replace dup = 1 in 589
replace dup = 1 in 595
replace dup = 1 in 597
replace dup = 1 in 599
replace dup = 1 in 601
replace dup = 1 in 603
replace dup = 1 in 613
replace dup = 1 in 626
replace dup = 1 in 633
replace dup = 1 in 679
replace dup = 1 in 681
replace dup = 1 in 694
replace dup = 1 in 696
replace dup = 1 in 706
replace dup = 1 in 708
replace dup = 1 in 710
replace dup = 1 in 762
replace dup = 1 in 764
replace dup = 1 in 766
replace dup = 1 in 768
replace dup = 1 in 770
replace dup = 1 in 772
replace dup = 1 in 787
replace dup = 1 in 789
replace dup = 1 in 791
replace dup = 1 in 821
replace dup = 1 in 823
replace dup = 1 in 826
replace dup = 1 in 828
replace dup = 1 in 835
replace dup = 1 in 845
replace dup = 1 in 847
replace dup = 1 in 849
replace dup = 1 in 859
replace dup = 1 in 866
replace dup = 1 in 868
replace dup = 1 in 870
replace dup = 1 in 879
replace dup = 1 in 881
replace dup = 1 in 883
replace dup = 1 in 888
replace dup = 1 in 890
replace dup = 1 in 892
replace dup = 1 in 895
replace dup = 1 in 907
replace dup = 1 in 914
replace dup = 1 in 916
replace dup = 1 in 918
replace dup = 1 in 920
replace dup = 1 in 922
replace dup = 1 in 927
replace dup = 1 in 929
replace dup = 1 in 931
replace dup = 1 in 961
replace dup = 1 in 963
replace dup = 1 in 968
replace dup = 1 in 970
replace dup = 1 in 972
replace dup = 1 in 974
replace dup = 1 in 976
replace dup = 1 in 978
replace dup = 1 in 980
replace dup = 1 in 992
replace dup = 1 in 994
replace dup = 1 in 1005
replace dup = 1 in 1014
replace dup = 1 in 1016
replace dup = 1 in 1018
replace dup = 1 in 1023
replace dup = 1 in 1025
replace dup = 1 in 1027
replace dup = 1 in 1029
replace dup = 1 in 1033
replace dup = 1 in 1035
replace dup = 1 in 1037
replace dup = 1 in 1039
replace dup = 1 in 1041
replace dup = 1 in 1057
replace dup = 1 in 1059
replace dup = 1 in 1065
replace dup = 1 in 1070
replace dup = 1 in 1072
replace dup = 1 in 1074
replace dup = 1 in 1079
replace dup = 1 in 1081
replace dup = 1 in 1083
replace dup = 1 in 1085
replace dup = 1 in 1087
replace dup = 1 in 1093
replace dup = 1 in 1095
replace dup = 1 in 1141
replace dup = 1 in 1147
replace dup = 1 in 1150
replace dup = 1 in 1163
replace dup = 1 in 1186
replace dup = 1 in 1188
replace dup = 1 in 1196
replace dup = 1 in 1255
replace dup = 1 in 1257
replace dup = 1 in 1259
replace dup = 1 in 1261
replace dup = 1 in 1352
replace dup = 1 in 1367
replace dup = 1 in 1369
replace dup = 1 in 1371
replace dup = 1 in 1423
replace dup = 1 in 1431
replace dup = 1 in 1433
replace dup = 1 in 1435
replace dup = 1 in 1440
drop if dup>0

order ubigeo year penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "CORRUPCIÓN INTENSA"
replace corrup_intensa = 0 if corrup_intensa == 1
replace corrup_intensa = 1 if corrup_intensa == 2
label define frec1 1 "Sí" 0 "No"
label list frec1
label values corrup_intensa frec1
codebook corrup_intensa

* variable "corrupción amplia"
gen corrup_amplia = 1 if civil != 0
replace corrup_amplia = 1 if penal != 0
replace corrup_amplia = 0 if corrup_amplia == .
tostring corrup_amplia, gen(str_corrup_amplia) force
encode str_corrup_amplia, gen(id_corrup_amplia)
drop corrup_amplia str_corrup_amplia
rename id_corrup_amplia corrup_amplia
label var corrup_amplia "CORRUPCIÓN AMPLIA"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio
label var monto_ "SUMA DE MONTOS: AUDITADO Y OBJETO"

* variable interactiva: monto auditado según prueba
gen monto = monto_auditado if tipo_control == 1
replace monto = monto_objeto_servicio if tipo_control == 2
label var monto "MONTO AUDITADO SEGÚN PRUEBA"

* variables interactivas: número de personas según tipo de corrupción
gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
label var per_corrup1 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN INTENSA"
label var per_corrup2 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN AMPLIA"

* variables interactivas monto según tipo de corrupción
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia
label var monto_corrup1 "MONTO SEGÚN CORRUPCIÓN INTENSA"
label var monto_corrup2 "MONTO SEGÚN CORRUPCIÓN AMPLIA"

save $data/c3, replace
/*  variables: 19
observaciones: 1,297  */


* (4) contraloria panel por ubigeo, caso y año
*----------------------------------------------

use $input\contraloria_panel, clear

rename año year

gen monto_auditado_promedio = monto_auditado / dif
gen monto_examinado_promedio = monto_examinado / dif
gen monto_objeto_promedio = monto_objeto_servicio / dif

drop monto_auditado monto_examinado monto_objeto_servicio

keep ubigeo year doc_name tipo_control penal civil admin adm_ent adm_pas monto_auditado_promedio monto_examinado_promedio monto_objeto_promedio
/*  variables: 12
observaciones: 1976  */

order ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado_promedio monto_examinado_promedio monto_objeto_promedio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "CORRUPCIÓN INTENSA"
replace corrup_intensa = 0 if corrup_intensa == 1
replace corrup_intensa = 1 if corrup_intensa == 2
label define frec1 1 "Sí" 0 "No"
label list frec1
label values corrup_intensa frec1
codebook corrup_intensa

* variable "corrupción amplia"
gen corrup_amplia = 1 if civil != 0
replace corrup_amplia = 1 if penal != 0
replace corrup_amplia = 0 if corrup_amplia == .
tostring corrup_amplia, gen(str_corrup_amplia) force
encode str_corrup_amplia, gen(id_corrup_amplia)
drop corrup_amplia str_corrup_amplia
rename id_corrup_amplia corrup_amplia
label var corrup_amplia "CORRUPCIÓN AMPLIA"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "monto_"
gen monto_ = monto_auditado_promedio + monto_objeto_promedio
label var monto_ "SUMA DE MONTOS: AUDITADO Y OBJETO"

* variable interactiva: monto auditado según prueba
gen monto = monto_auditado_promedio if tipo_control == 1
replace monto = monto_objeto_promedio if tipo_control == 2
label var monto "MONTO AUDITADO SEGÚN PRUEBA"

* variables interactivas: número de personas según tipo de corrupción
gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
label var per_corrup1 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN INTENSA"
label var per_corrup2 "NÚMERO DE PERSONAS SEGÚN CORRUPCIÓN AMPLIA"

* variables interactivas monto según tipo de corrupción
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia
label var monto_corrup1 "MONTO SEGÚN CORRUPCIÓN INTENSA"
label var monto_corrup2 "MONTO SEGÚN CORRUPCIÓN AMPLIA"

save $data/c4, replace
/*  variables: 20
observaciones: 1,976 */


********************************************************************************
* UNIÓN DE LOS CUATRO CASOS CON LAS BASES RENAMU - SIAF
********************************************************************************

* RENAMU - SIAF
use $input\matrix_renamu, clear
rename idmunici ubigeo
merge 1:1 ubigeo year using $input\matrix_siaf_l
drop _merge
save $input/matrix_renamu_siaf, replace
/*  variables: 5,408
observaciones: 22,250  */


* (1) contraloría del año inicial del reporte por ubigeo y año
*--------------------------------------------------------------
use $input/matrix_renamu_siaf, clear
merge 1:m ubigeo year using $data/c1
/*  variables: 5,426
observaciones: 22,255  */
drop if _merge != 3
drop _merge
save $data/matrix_c1, replace
/*  variables: 5,425
observaciones: 652  */


* (2) contraloría del año inicial del reporte por ubigeo, caso y año
*--------------------------------------------------------------------
use $input/matrix_renamu_siaf, clear
merge 1:m ubigeo year using $data/c2
/*  variables: 5,427
observaciones: 22,448  */
drop if _merge != 3
drop _merge
save $data/matrix_c2, replace
/*  variables: 5,426
observaciones: 845  */


* (3) contraloría panel por ubigeo y año
*----------------------------------------
use $input/matrix_renamu_siaf, clear
merge 1:m ubigeo year using $data/c3
/*  variables: 5,426
observaciones: 22,257  */
drop if _merge != 3
drop _merge
save $data/matrix_c3, replace
/*  variables: 5,425
observaciones: 1,290  */


* (4) contraloria panel por ubigeo, caso y año
*----------------------------------------------
use $input/matrix_renamu_siaf, clear
merge 1:m ubigeo year using $data/c4
/*  variables: 5,427
observaciones: 22,936  */
drop if _merge != 3
drop _merge
save $data/matrix_c4, replace
/*  variables: 5,426
observaciones: 1,969  */

erase $input/matrix_renamu_siaf.dta
erase $data/c1.dta
erase $data/c2.dta
erase $data/c3.dta
erase $data/c4.dta


********************************************************************************
* EXPORTAR LISTAS DE VARIABLES DE CADA UNA DE LAS BASES
********************************************************************************

* RENAMU
use "$input/matrix_renamu", clear
describe, replace
export excel name varlab using "$varnames/renamu_variables.xlsx", firstrow(variables)

* SIAF FINAL
use "$input/matrix_siaf_l", clear
describe, replace
export excel name varlab using "$varnames/siaf_variables.xlsx", firstrow(variables)

* CONTRALORIA
use "$input/matrix_contraloria", clear
describe, replace
export excel name varlab using "$varnames/contraloria_variables.xlsx", firstrow(variables)


********************************************************************************
* IETOOLKIT
********************************************************************************
ssc install iefieldkit

* (1) contraloría del año inicial del reporte por ubigeo y año
*--------------------------------------------------------------
use $data/matrix_c1, clear
iecodebook template using "$iecodebook\cleaning_c1.xlsx", replace
iecodebook apply using "$iecodebook\cleaning_c1.xlsx"

* (2) contraloría del año inicial del reporte por ubigeo, caso y año
*--------------------------------------------------------------------
use $data/matrix_c2, clear
iecodebook template using "$iecodebook\cleaning_c2.xlsx", replace
iecodebook apply using "$iecodebook\cleaning_c2.xlsx"

* (3) contraloría panel por ubigeo y año
*----------------------------------------
use $data/matrix_c3, clear
iecodebook template using "$iecodebook\cleaning_c3.xlsx", replace
iecodebook apply using "$iecodebook\cleaning_c3.xlsx"

* (4) contraloria panel por ubigeo, caso y año
*----------------------------------------------
use $data/matrix_c4, clear
iecodebook template using "$iecodebook\cleaning_c4.xlsx", replace
iecodebook apply using "$iecodebook\cleaning_c4.xlsx"

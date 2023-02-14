/********************************************************************************
			PROYECTO CORRUPCIÓN
********************************************************************************/

clear all
cls

set maxvar 10000

if "`c(username)'" == "dell" global main "C:\Users\dell\Documents\QLAB\Corruption_Paper"

if "`c(username)'" == "Usuario" global main "C:\Users\Usuario\Desktop\QLAB\GitHub\Corruption_Paper"

global input "$main\input"
global data "$main\output\data"
global extra "$main\extra"
global varnames "$main\extra\varnames"
global iecodebook "$main\extra\iecodebook"

*==========================================================================
* BASE CONTRALORIA: CONSTRUCCIÓN DE CUATRO CASOS DE VARIABLES DEPENDIENTES
*==========================================================================

* (1) contraloría del año inicial del reporte por ubigeo y año
*--------------------------------------------------------------

use $input\contraloria_caso, clear

rename año_inicio year
collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year tipo_control)
/*  variables: 10
observaciones: 656  */

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
/*  variables: 10
observaciones: 1297  */

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
merge 1:1 ubigeo year using $input\matrix_siaf
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
use "$input/matrix_siaf", clear
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

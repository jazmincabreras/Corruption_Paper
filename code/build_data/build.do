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
*global casos_contraloria "$main\casos_contraloria"
*global matrix_casos "$main\matrix_casos"
global extra "$main\extra"
global varnames "$main\extra\varnames"

*==========================================================================
* BASE CONTRALORIA: CONSTRUCCIÓN DE CUATRO CASOS DE VARIABLES DEPENDIENTES
*==========================================================================

* (1) contraloría inicial por ubigeo y año inicial del reporte
*--------------------------------------------------------------

use "$input\matrix_datospanel", clear

collapse (first) ubigeo año_in civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (doc_name)
rename año_in year
collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year)
/*  variables: 10
observaciones: 657  */

order ubigeo year penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "Corrupción intensa"
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
label var corrup_amplia "Corrupción amplia"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "prueba", que determina si una observacion es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad)
gen prueba = 1 if (monto_auditado!= . & monto_examinado!= . & monto_objeto_servicio == .)
replace prueba = 2 if (monto_auditado== . & monto_examinado== . & monto_objeto_servicio!= .)
codebook prueba
sort prueba

* variable "monto"
gen monto = monto_auditado if prueba == 1
replace monto = monto_objeto_servicio if prueba == 2

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio

gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia

save "$data/c1", replace


* (2) contraloría inicial por ubigeo, caso y año inicial del reporte
*--------------------------------------------------------------------

use "$input\matrix_datospanel", clear

collapse (first) año_in civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (doc_name ubigeo)
rename año_in year
/*  variables: 11
observaciones: 850  */

order ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "Corrupción intensa"
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
label var corrup_amplia "Corrupción amplia"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "prueba", que determina si una observacion es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad)
gen prueba = 1 if (monto_auditado!= . & monto_examinado!= . & monto_objeto_servicio == .)
replace prueba = 2 if (monto_auditado== . & monto_examinado== . & monto_objeto_servicio!= .)
codebook prueba
sort prueba

* variable "monto"
gen monto = monto_auditado if prueba == 1
replace monto = monto_objeto_servicio if prueba == 2

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio

gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia

save "$data/c2", replace


* (3) contraloría panel por ubigeo y año
*----------------------------------------

use "$input\matrix_datospanel", clear
collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year)
/*  variables: 10
observaciones: 1297  */
*sum o media

order ubigeo year penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "Corrupción intensa"
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
label var corrup_amplia "Corrupción amplia"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "prueba", que determina si una observacion es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad)
gen prueba = 1 if (monto_auditado!= . & monto_examinado!= . & monto_objeto_servicio == .)
replace prueba = 2 if (monto_auditado== . & monto_examinado== . & monto_objeto_servicio!= .)
codebook prueba
sort prueba

* variable "monto"
gen monto = monto_auditado if prueba == 1
replace monto = monto_objeto_servicio if prueba == 2

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio

gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia

save "$data/c3", replace


* (4) contraloria panel por ubigeo, año y caso
*----------------------------------------------

use "$input\matrix_datospanel", clear
keep ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio
/*  variables: 11
observaciones: 1976  */

order ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio

* variable "corrupción intensa"
gen corrup_intensa = 1 if penal != 0
replace corrup_intensa = 0 if corrup_intensa == .
tostring corrup_intensa, gen(str_corrup_intensa) force
encode str_corrup_intensa, gen(id_corrup_intensa)
drop corrup_intensa str_corrup_intensa
rename id_corrup_intensa corrup_intensa
label var corrup_intensa "Corrupción intensa"
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
label var corrup_amplia "Corrupción amplia"
replace corrup_amplia = 0 if corrup_amplia == 1
replace corrup_amplia = 1 if corrup_amplia == 2
label list frec1
label values corrup_amplia frec1
codebook corrup_amplia

* variable "prueba", que determina si una observacion es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad)
gen prueba = 1 if (monto_auditado!= . & monto_examinado!= . & monto_objeto_servicio == .)
replace prueba = 2 if (monto_auditado== . & monto_examinado== . & monto_objeto_servicio!= .)
codebook prueba
sort prueba

* variable "monto"
gen monto = monto_auditado if prueba == 1
replace monto = monto_objeto_servicio if prueba == 2

* variable "monto_"
gen monto_ = monto_auditado + monto_objeto_servicio

gen per_corrup1 = penal * corrup_intensa
gen per_corrup2 = civil * corrup_amplia
gen monto_corrup1 = monto * corrup_intensa
gen monto_corrup2 = monto * corrup_amplia

save "$data/c4", replace


********************************************************************************
* NUEVOS DOS CASOS
********************************************************************************

* (5) contraloría panel por ubigeo y año
*----------------------------------------

use "$contraloria\datos_panel", clear

gen X = monto_auditado / dif
gen Y = monto_examinado / dif
gen Z = monto_objeto_servicio / dif

drop monto_auditado monto_examinado monto_objeto_servicio
rename (X Y Z) (monto_auditado monto_examinado monto_objeto_servicio)

collapse (sum) civil penal admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio, by (ubigeo year)
/*  variables: 10
observaciones: 1297  */

order ubigeo year penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio


* (6) contraloria panel por ubigeo, año y caso
*----------------------------------------------

use "$contraloria\datos_panel", clear

gen X = monto_auditado / dif
gen Y = monto_examinado / dif
gen Z = monto_objeto_servicio / dif

drop monto_auditado monto_examinado monto_objeto_servicio
rename (X Y Z) (monto_auditado monto_examinado monto_objeto_servicio)

keep ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio
/*  variables: 11
observaciones: 1976  */

order ubigeo year doc_name penal civil admin adm_ent adm_pas monto_auditado monto_examinado monto_objeto_servicio


*===========================================
* UNIÓN DE LAS BASES CON LOS CASOS CREADOS
*===========================================

* SIAF (gc_funcs, hk_funcs y siaf_final)
use "$bases/gc_funcs", clear
merge 1:1 ubigeo year using "$bases/gk_funcs"
drop _merge
save "$bases/siaf_gcgk", replace
use "$bases/siaf_gcgk", clear
merge 1:1 ubigeo year using "$bases/siaf_final"
drop _merge
save "$bases/matrix_siaf", replace
erase "$bases/siaf_gcgk.dta"
/*  variables: 
observaciones:   */

* RENAMU - SIAF
use "$bases/matrix_renamu", clear
rename idmunici ubigeo
merge 1:1 ubigeo year using "$bases/siaf"
drop _merge
save "$bases/renamu_siaf", replace
/*  variables: 
observaciones:   */







* (1) contraloría inicial por ubigeo y año inicial del reporte
*--------------------------------------------------------------


* 4. CONSTRUCCION DE LAS CUATRO BASES FINALES *
***********************************************

* 4.1. Caso 1: Contraloría inicial por ubigeo y año
* -------------------------------------------------
use "$bp/renamu_siaf", clear
merge 1:m ubigeo year using "$bp/MATRIX_c1"
//drop if _merge != 3
save "$bf/bf_inicial_c1", replace
/*
variables:5,714
observaciones: 22,255
*/


* 4.2. Caso 2: Contraloria inicial por ubigeo, año y caso
* -------------------------------------------------------
use "$bp/renamu_siaf", clear
merge 1:m ubigeo year using "$bp/contraloria_inicial_c2"
save "$bf/bf_inicial_c2", replace
/*
variables:5,716
observaciones: 22,448
*/


* 4.3. Caso 3: Contraloria panel por ubigeo y año
* -----------------------------------------------
use "$bp/renamu_siaf", clear
merge 1:m ubigeo year using "$bp/contraloria_panel_c1"
save "$bf/bf_panel_c1", replace
/*
variables:5,714
observaciones: 22,257
*/


* 4.4. Caso 4: Contraloria panel por ubigeo, año y caso
* -------------------------------------------------------
use "$bp/renamu_siaf", clear
merge 1:m ubigeo year using "$bp/contraloria_panel_c2"
save "$bf/bf_panel_c2", replace
/*
variables:5,716
observaciones: 22,936
*/


* 5. EXPORTAR LISTAS DE VARIABLES DE CADA UNA DE LAS BASES *
************************************************************
/********************************************************************************
			PROYECTO CORRUPCIÓN
********************************************************************************/

* 5.1. Renamu
use "$bases/matrix_renamu", clear
describe, replace
export excel name varlab using "$varnames/renamu_variables.xlsx", firstrow(variables)

* 5.2. SIAF Final
use "$bases/matrix_siaf", clear
describe, replace
export excel name varlab using "$varnames/siaf_variables.xlsx", firstrow(variables)

* 5.3. Contraloria
use "$bases/matrix_datospanel", clear
describe, replace
export excel name varlab using "$varnames/contraloria_variables.xlsx", firstrow(variables)

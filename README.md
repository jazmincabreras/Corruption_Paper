# CORRUPTION PAPER - EMPIRICAL ANALYSIS

## 1. Información General

El proyecto combina tres bases de datos (renamu, siaf y sentencias) que fueron procesadas arbitrariamente para el presente proyecto.

* Primer procesamiento

A partir de la primera limpieza realizada a la base sentencias se procedió a clasificar la corrupción para el caso peruano en dos niveles, el cual estuvo basado en el análisis de (Avis et. al, 2019 : 1924) en el cual clasifica las irregularidades de la misma base de datos usada en Brollo (2013) en tres niveles (i) mal manejo, (ii) corrupción moderada, y (iii) corrupción severa. Por lo que, para determinar los parámetros de los niveles de corrupción en el Perú la clasificación de las dos nuevas variables dummy fueron consultadas con abogados, donde se obtuvo que los reportes de sentencias se considerarán como (1) corrupción intensa siempre y cuando las sentencias indiquen que por lo menos a una persona cometió un delito penal; y (2) corrupción amplia siempre y cuando las sentencias indiquen que por lo menos a una persona cometió un delito civil o uno penal. De esta manera, se obtiene que la gravedad de los delitos cumple la siguiente regla de gravedad: administrativos < civil < penal. Por otro lado, para generar la variable monto se utilizaron las dos variables existentes en los reportes de las sentencias, se cumple por tanto que monto es igual a la suma del monto auditado presente y el monto objeto de servicio presente.
A partir de las variables dummys creadas se optó por generar cuatro variables interactivas que multiplican los valores de las variables numéricas y los valores de las categorías de las variables dummys: (1) número de personas que cometieron corrupción del primer nivel, (2) número de personas que cometieron corrupción del segundo nivel, (3) monto total de sentencias que se encuentran en el primer nivel de corrupción y (4) monto total de sentencias que se encuentran en el segundo nivel de corrupción.

* Segundo procesamiento

De acuerdo a las necesidades del proyecto corrupción se construyeron cuatro casos de variables dependientes. (1) El primer caso, considera a la contraloría inicial por ubigeo y año de cada reporte de sentencia, este caso es conocido como el caso inicial debido a que fue colapsado en base al año inicial de casa caso por caso [variables: 17 / observaciones: 657]. (2) En el segundo caso, donde se toma a la contraloría inicial colapsado por ubigeo, año inicial y caso, el cual también se encuentra en función del primer año de cada caso por caso; y se incluye a la variable prueba que determina si una observación es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad) [variables: 19 / observaciones: 850]. (3) Para el tercer caso se tiene a la contraloría panel que toma las diferencias entre el primer año y el último año de sentencia de acuerdo al reporte colapsada por ubigeo y año de diferencias del reporte [variables: 17 / observaciones: 1297]. (4) Por último, el cuarto caso toma a la contraloría panel que toma las diferencias entre el primer año y el último año de sentencia de acuerdo al reporte colapsada por ubigeo, año y caso del reporte de sentencia, donde además se incluye a la variable prueba que determina si una observación es AC (Auditoria de cumplimiento) o SCEHPI (Servicio de Control Específico a Hechos de Presunta Irregularidad) [variables: 19 / observaciones: 1976].

* Tercer procesamiento

Se realiza la unión de la base renamu y siaf (renamu_siaf), para finalizar la construcción de las bases finales para cada uno de los cuatro casos generados (1) contraloría inicial por ubigeo y año, (2) contraloria inicial por ubigeo, año y caso, (3) contraloria panel por ubigeo y año, y (4) contraloria panel por ubigeo, año y caso.


## 2. Procesamiento en Python

1.- Cargar los datos

1.1. Importar librerias y módulos

1.2. Importar bases

1.3. Filtrar solo aquellas variables que hicieron match

1.4. Última limpieza a las bases


## 3.	Bibliografía

Avis, Eric; Ferraz, C; Finan, F; (2018) “Do Govermente audits reduce corruption? Estimating the impacts of exposing corrupt Politicians”. Journal of Political Economy

Brollo, Fernanda (2013) “The Political Resource Curse” American Economic Review. Vol. 103 N-5

INEI (2020) “Estimación de la vulnerabilidad económica a la pobreza monetaria”

Ferraz, C., & Finan, F. (2008). Exposing corrupt politicians: the effects of Brazil's publicly released audits on electoral outcomes. The Quarterly journal of economics, 123(2), 703-745.

Olken, B. A., & Pande, R. (2012). Corruption in developing countries. Annu. Rev. Econ., 4(1), 479-509.

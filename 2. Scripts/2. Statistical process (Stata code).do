/*------------------------------------------------------------------------------
-----------"Urban splawl and forced migration: A study of forced"---------------
----------------"migration and urbanization in Colombia"------------------------
------------------------------------------------------------------------------*/

clear
/* Arreglos Previos*/{
/*Trabajo en Casa
cd "C:\Users\Pachito\Desktop\2. Expansión Urbana\Resultados Finales"
use "C:\Users\Pachito\Desktop\2. Expansión Urbana\Panel_expnasion_urbana.dta", clear
*/

/*Trabajo Laboratorio Urbano
cd "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\ResultadosFINALES"
use "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\Panel_expnasion_urbana.dta"
*/

/*Trabajo donde Cangu
cd "C:\Users\ortiz\Desktop\1. Expansión Urbana\Resultados Finales"
use "C:\Users\ortiz\Desktop\1. Expansión Urbana\Panel_expnasion_urbana.dta", clear
*/


*Sintaxis de "Outreg2"
// outreg2 using Modelos1992_1998_m1.xls, replace excel dec(3)ctitle (Modelo 1 (1 lag))
}

/*1. Analisis de DATOS PANEL*/{ /* --------------> ARREGLAR ApSE y ApCE*/
/*PASOS RREVIOS: Descripción de variables*/{
rename Municipio Municipalities
rename Tiempo Times
rename HA_Totales Municipal_HA
rename BonoDem Demographic_Bonus
rename BonoCuadrado Demographic_Bsqrt
rename PobUrb_Inicial Initial_UrbPOP
rename PobUrb_Final Final_UrbPOP
rename PORCEDefores00_17 ForestLoss0017
rename FFMlag1 FMFlag1
rename FFMlag12 FMFlag12 
rename FFMlag0 FMFlag0


global Dependent AAC ApSE ApSC
global FMFgeneral FMFlag1 FMFlag12 FMFlag0
global xPermanent Times Initial_UrbPOP Demographic_Bonus Demographic_Bsqrt DistCapitalKM ForestLoss0017

///A. Establecer base como PANEL
sort Municipalities Times
xtset Municipalities Times


///B. Descripción #2 de lla información
xtsum Municipalities Times $Dependent
xtsum $FMFgeneral Initial_UrbPOP Final_UrbPOP Demographic_Bonus Demographic_Bsqrt ForestLoss0017 Municipal_HA





}



//1. Modelos Panel

	/*1.1. Modelos sobre la dependiende AAC (Averege Anthropogenic Change): M1 to M9*/{

		/*1.1.1. AAC PULLED MODELS(MCO): M1 to M3*/{

			/* 1.1.1.1. MCO lag 1 -> "M1"*/{

xtreg AAC FMFlag1 $xPermanent, robust
est store M1
outreg2 using 1_Panel_ACC.xls, replace excel dec(3) ctitle (AAC-FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.2. MCO lag 1/2 -> "M2"*/{

xtreg AAC FMFlag12 $xPermanent, robust
est store M2
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-F 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.3. MCO lag 0 -> "M3"*/{

xtreg AAC FMFlag0 $xPermanent, robust
est store M3
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}

		/*1.1.2. AAC FIXED EFFECTS MODELS(FE): M4 to M6*/{

			/* 1.1.2.1. FE lag 4 -> "M4"*/{

xtreg AAC FMFlag1 $xPermanent, fe 
est store M4
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.2.2. FE lag 1/2 -> "M5"*/{

xtreg AAC FMFlag12 $xPermanent, fe
est store M5
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.2.3. FE lag 0 -> "M6"*/{

xtreg AAC FMFlag0 $xPermanent, fe
est store M6
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}

		/*1.1.3. RANDOM EFFECTS MODELS(RE): M7 to M9*/{

			/* 1.1.3.1. RE lag 4 -> "M7"*/{

xtreg AAC FMFlag1 $xPermanent, re theta
est store M7
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.2. RE lag 1/2 -> "M8"*/{

xtreg AAC FMFlag12 $xPermanent, re theta
est store M8
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.3. RE lag 0 -> "M9"*/{

xtreg AAC FMFlag0 $xPermanent, re theta
est store M9
outreg2 using 1_Panel_ACC.xls, append excel dec(3) ctitle (AAC-FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}


		/*Pruebas HAUSMAN de modelos*/{
*Prubea de Housman (HO: Coeficientes NO se diferencian sisteáticamente ERGO mejor usar RE)

hausman M4 M7 /* Modelos a 1 lag
chi2(2) = 107.50
Prob>chi2 = 0.0000 */

hausman M5 M8 /* Modelos a 1/2 lag
chi2(2) = 111.15
Prob>chi2 = 0.0000 */

hausman M6 M9 /* Modelos a 0 lag
chi2(2) = 118.04
Prob>chi2 = 0.0000 */
}
		/*Pruebas BREUSCH-PAGAN de modelos*/{
*Prueba de Breusch Pagan (HO: Mejor usar OLS)

est replay M7
xttest0  /* HO: A 1 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */


est replay M8
xttest0  /* HO: A 1/2 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */

est replay M9
xttest0 
/* HO: A 0 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */
		
}




break}
/*----------------------------------------------------------------------------*/
	/*1.2. Modelos sobre la dependiende ApSE (Anthropogenic Print Spatail Expansion): M1 to M9*/{

		/*1.1.1. AAC PULLED MODELS(MCO): M1 to M3*/{

			/* 1.1.1.1. MCO lag 1 -> "M1"*/{

xtreg ApSE FMFlag1 $xPermanent, robust
est store M1
outreg2 using 1_Panel_ApSE.xls, replace excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.2. MCO lag 1/2 -> "M2"*/{

xtreg ApSE FMFlag12 $xPermanent, robust
est store M2
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.3. MCO lag 0 -> "M3"*/{

xtreg ApSE FMFlag0 $xPermanent, robust
est store M3
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}

		/*1.1.2. AAC FIXED EFFECTS MODELS(FE): M4 to M6*/{

			/* 1.1.2.1. FE lag 4 -> "M4"*/{

xtreg ApSE FMFlag1 $xPermanent, fe 
est store M4
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.2.2. FE lag 1/2 -> "M5"*/{

xtreg ApSE FMFlag12 $xPermanent, fe
est store M5
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.2.3. FE lag 0 -> "M6"*/{

xtreg ApSE FMFlag0 $xPermanent, fe
est store M6
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}

		/*1.1.3. RANDOM EFFECTS MODELS(RE): M7 to M9*/{

			/* 1.1.3.1. RE lag 4 -> "M7"*/{

xtreg ApSE FMFlag1 $xPermanent, re theta
est store M7
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.2. RE lag 1/2 -> "M8"*/{

xtreg ApSE FMFlag12 $xPermanent, re theta
est store M8
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.3. RE lag 0 -> "M9"*/{

xtreg ApSE FMFlag0 $xPermanent, re theta
est store M9
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}


		/*Pruebas HAUSMAN de modelos*/{
*Prubea de Housman (HO: Coeficientes NO se diferencian sisteáticamente ERGO mejor usar RE)

hausman M4 M7 /* Modelos a 1 lag
chi2(2) = 107.50
Prob>chi2 = 0.0000 */

hausman M5 M8 /* Modelos a 1/2 lag
chi2(2) = 111.15
Prob>chi2 = 0.0000 */

hausman M6 M9 /* Modelos a 0 lag
chi2(2) = 118.04
Prob>chi2 = 0.0000 */
}
		/*Pruebas BREUSCH-PAGAN de modelos*/{
*Prueba de Breusch Pagan (HO: Mejor usar OLS)

est replay M7
xttest0  /* HO: A 1 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */


est replay M8
xttest0  /* HO: A 1/2 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */

est replay M9
xttest0 
/* HO: A 0 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */
		
}




break}
/*----------------------------------------------------------------------------*/
	/*1.3. Modelos sobre la dependiende ApCE (Anthropogenic Print Spatail Contraction): M1 to M9*/{

		/*1.1.1. AAC PULLED MODELS(MCO): M1 to M3*/{

			/* 1.1.1.1. MCO lag 1 -> "M1"*/{

xtreg ApSE FMFlag1 $xPermanent, robust
est store M1
outreg2 using 1_Panel_ApSE.xls, replace excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.2. MCO lag 1/2 -> "M2"*/{

xtreg ApSE FMFlag12 $xPermanent, robust
est store M2
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.1.3. MCO lag 0 -> "M3"*/{

xtreg ApSE FMFlag0 $xPermanent, robust
est store M3
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}
/*----------------------------------------------------------------------------*/
		/*1.1.2. AAC FIXED EFFECTS MODELS(FE): M4 to M6*/{

			/* 1.1.3.1. FE lag 4 -> "M4"*/{

xtreg ApSE FMFlag1 $xPermanent, fe 
est store M4
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.2. FE lag 1/2 -> "M5"*/{

xtreg ApSE FMFlag12 $xPermanent, fe
est store M5
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.3. FE lag 0 -> "M6"*/{

xtreg ApSE FMFlag0 $xPermanent, fe
est store M6
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}

		/*1.1.3. RANDOM EFFECTS MODELS(RE): M7 to M9*/{

			/* 1.1.3.1. RE lag 4 -> "M7"*/{

xtreg ApSE FMFlag1 $xPermanent, re theta
est store M7
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.2. RE lag 1/2 -> "M8"*/{

xtreg ApSE FMFlag12 $xPermanent, re theta
est store M8
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho)
}
			/* 1.1.3.3. RE lag 0 -> "M9"*/{

xtreg ApSE FMFlag0 $xPermanent, re theta
est store M9
outreg2 using 1_Panel_ApSE.xls, append excel dec(3) ctitle (FMF 0 lag) e(r2_o r2_b r2_w rho)
}
}


		/*Pruebas HAUSMAN de modelos*/{
*Prubea de Housman (HO: Coeficientes NO se diferencian sisteáticamente ERGO mejor usar RE)

hausman M4 M7 /* Modelos a 1 lag
chi2(2) = 107.50
Prob>chi2 = 0.0000 */

hausman M5 M8 /* Modelos a 1/2 lag
chi2(2) = 111.15
Prob>chi2 = 0.0000 */

hausman M6 M9 /* Modelos a 0 lag
chi2(2) = 118.04
Prob>chi2 = 0.0000 */
}
		/*Pruebas BREUSCH-PAGAN de modelos*/{
*Prueba de Breusch Pagan (HO: Mejor usar OLS)

est replay M7
xttest0  /* HO: A 1 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */


est replay M8
xttest0  /* HO: A 1/2 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */

est replay M9
xttest0 
/* HO: A 0 lag es mejor un modelo OLS que cualquiera de efetos observacionales
chibar2(01) = 0.00
Prob>chi2 = 1.0000 */
		
}




break








}
//Pruebas Iniciales:
xtreg AAC FMFlag12 $xPermanent, fe mle
outreg2 using 1_Panel_ACC.xls, replace excel dec(3) ctitle (FMF 1/2 lag) e(r2_o r2_b r2_w rho aic)
}


/*2. Análisis de SECCION TRANSVRSAL*/{
*Trabajo en Casa
cd "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\ResultadosFINALES"
use "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\1. DTA_Seccion_Tranversal_Normal.dta", clear
*

/*Trabajo donde Cangu
use "C:\Users\ortiz\Desktop\1. Expansión Urbana\1. DTA sección transversal FINAL.dta", clear
*/
replace DistCapitalKM = 1 if DistCapitalKM ==0
gen logDistCAP = log(DistCapitalKM)


	/*2.1. Modelos sobre la dependiente AAC (Averege Anthropogenic Change): */{

/*2.1.1.  1 lag Models*/{
reg AACT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AAC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, replace excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 AAC)

reg AACT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AAC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 AAC)
	
reg AACT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AAC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 AAC)
}

/*2.1.2.  1/2 lag Models*/{

reg AACT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AAC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 AAC)

reg AACT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AAC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 AAC)
	
reg AACT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AAC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 AAC2)
}

/*2.1.3.  0 lag Models*/{

reg AACT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AAC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 AAC)

reg AACT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AAC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 AAC)
	
reg AACT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AAC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 AAC)

}
}
*

	/*2.2. Modelos sobre la dependiente ApSE (Anthropogenic Print Spatail Expansion): */{
	
/*2.2.1.  1 lag Models*/{
reg ApSET1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPE_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSE)

reg ApSET2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPE_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSE)
	
reg ApSET3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPE_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSE)
}

/*2.2.2.  1/2 lag Models*/{

reg ApSET1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPE_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSE)

reg ApSET2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPE_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSE)
	
reg ApSET3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPE_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSE)
}

/*2.2.3.  0 lag Models*/{

reg ApSET1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPE_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSE)

reg ApSET2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPE_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSE)
	
reg ApSET3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPE_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSE)

}
}
*

	/*2.3. Modelos sobre la dependiente ApSC (Anthropogenic Print Spatail Contasction): */{

/*2.3.1.  1 lag Models*/{
reg ApSCT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSC)

reg ApSCT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSC)
	
reg ApSCT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSC)
}

/*2.3.2.  1/2 lag Models*/{

reg ApSCT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSC)

reg ApSCT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSC)
	
reg ApSCT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSC)
}

/*2.3.3.  0 lag Models*/{

reg ApSCT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, robust
est store AsPC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSC)

reg ApSCT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, robust
est store AsPC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSC)
	
reg ApSCT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, robust
est store AsPC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_Seccion_Tranversal.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSC)


est stats AAC_T1_lag1 AAC_T2_lag1 AAC_T3_lag1 AAC_T1_lag12 AAC_T2_lag12 AAC_T3_lag12 AAC_T1_lag0 AAC_T2_lag0 AAC_T3_lag0 AsPE_T1_lag1 AsPE_T2_lag1 AsPE_T3_lag1 AsPE_T1_lag12 AsPE_T2_lag12 AsPE_T3_lag12 AsPE_T1_lag0 AsPE_T2_lag0 AsPE_T3_lag0 AsPC_T1_lag1 AsPC_T2_lag1 AsPC_T3_lag1 AsPC_T1_lag12 AsPC_T2_lag12 AsPC_T3_lag12 AsPC_T1_lag0 AsPC_T2_lag0 AsPC_T3_lag0

}
}
}
*


/*ECONOMETRIA ESPACIAL*/

/*AJUSTES PREVIOS*/{

*Trabajo en Casa
clear
cd "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\ResultadosFINALES"
use "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\Analisis Econometria EspaciaL\2. SeccionTranversalEspacial1041.dta", clear

replace DistCapitalKM = 1 if DistCapitalKM ==0
gen logDistCAP = log(DistCapitalKM)

set matsize 1500
spatwmat using "C:\Users\guibor.camargo\Desktop\1. Expansión Urbana\5. Modelación Econométrica\Analisis Econometria EspaciaL\3. PesosEspaciales1041.dta", name(W) eigenval(E) standardize

*https://www.youtube.com/watch?v=t7ADnMffink&index=3&list=PLRW9kMvtNZOhUEXPuisI8auLr9rQaGWnd
*http://wlm.userweb.mwn.de/wstaspwm.htm
*https://www.youtube.com/watch?v=54HoO0KgWLQ

/*
The following matrices have been created:

1. Imported binary weights matrix W(row-standardized)
   Dimension: 1120x1120

2. Eigenvalues matrix E
   Dimension: 1120x1
*/
*local Rho: display r(est)
*eret list
*e(sqCorr)
}


/*3. Análisis de MODELOS de LAG ESPACIALES*/{
*Trabajo en Laboratiorio Urbano




 /*3.1. Modelos sobre la dependiente AAC (Averege Anthropogenic Change): */{

/*3.1.1.  1 lag Models*/{
spatreg AACT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, replace excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 AAC)

spatreg AACT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 AAC)
 
spatreg AACT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 AAC)
}

/*3.1.2.  1/2 lag Models*/{

spatreg AACT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 AAC)

spatreg AACT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 AAC)
 
spatreg AACT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 AAC2)
}

/*3.1.3.  0 lag Models*/{
spatreg AACT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 AAC)

spatreg AACT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 AAC)
 
spatreg AACT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 AAC2)
}

/*3.1.3.  0 lag Models*/{

spatreg AACT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 AAC)

spatreg AACT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 AAC)
 
spatreg AACT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AAC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 AAC)

}
}
*

 /*3.2. Modelos sobre la dependiente ApSE (Anthropogenic Print Spatail Expansion): */{
 
/*3.2.1.  1 lag Models*/{
spatreg ApSET1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSE)

spatreg ApSET2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSE)
 
spatreg ApSET3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSE)
}

/*3.2.2.  1/2 lag Models*/{

spatreg ApSET1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSE)

spatreg ApSET2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSE)
 
spatreg ApSET3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSE)
}

/*3.2.3.  0 lag Models*/{

spatreg ApSET1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSE)

spatreg ApSET2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSE)
 
spatreg ApSET3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPE_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSE)

}
}
*

 /*3.3. Modelos sobre la dependiente ApSC (Anthropogenic Print Spatail Contasction): */{

/*3.3.1.  1 lag Models*/{
spatreg ApSCT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSC)

spatreg ApSCT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSC)
 
spatreg ApSCT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSC)
}

/*3.3.2.  1/2 lag Models*/{

spatreg ApSCT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSC)

spatreg ApSCT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSC)
 
spatreg ApSCT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSC)
}

/*3.3.3.  0 lag Models*/{

spatreg ApSCT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSC)

spatreg ApSCT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSC)
 
spatreg ApSCT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (lag)
est store AsPC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSC)

est stats AAC_T1_lag1 AAC_T2_lag1 AAC_T3_lag1 AAC_T1_lag12 AAC_T2_lag12 AAC_T3_lag12 AAC_T1_lag0 AAC_T2_lag0 AAC_T3_lag0 AsPE_T1_lag1 AsPE_T2_lag1 AsPE_T3_lag1 AsPE_T1_lag12 AsPE_T2_lag12 AsPE_T3_lag12 AsPE_T1_lag0 AsPE_T2_lag0 AsPE_T3_lag0 AsPC_T1_lag1 AsPC_T2_lag1 AsPC_T3_lag1 AsPC_T1_lag12 AsPC_T2_lag12 AsPC_T3_lag12 AsPC_T1_lag0 AsPC_T2_lag0 AsPC_T3_lag0


}
}
}


/*4. Análisis de MODELOS de ERROR ESPACIAL*/{
*Trabajo en Laboratiorio Urbano




 /*4.1. Modelos sobre la dependiente AAC (Averege Anthropogenic Change): */{

/*4.1.1.  1 lag Models*/{
spatreg AACT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, replace excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 AAC)

spatreg AACT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 AAC)
 
spatreg AACT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 AAC)
}

/*4.1.2.  1/2 lag Models*/{

spatreg AACT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 AAC)

spatreg AACT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 AAC)
 
spatreg AACT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 AAC2)
}

/*4.1.3.  0 lag Models*/{
spatreg AACT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 AAC)

spatreg AACT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 AAC)
 
spatreg AACT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 AAC2)
}

/*4.1.3.  0 lag Models*/{

spatreg AACT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 AAC)

spatreg AACT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 AAC)
 
spatreg AACT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AAC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 AAC)

}
}
*

 /*4.2. Modelos sobre la dependiente ApSE (Anthropogenic Print Spatail Expansion): */{
 
/*4.2.1.  1 lag Models*/{
spatreg ApSET1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSE)

spatreg ApSET2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSE)
 
spatreg ApSET3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSE)
}

/*4.2.2.  1/2 lag Models*/{

spatreg ApSET1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSE)

spatreg ApSET2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSE)
 
spatreg ApSET3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSE)
}

/*4.2.3.  0 lag Models*/{

spatreg ApSET1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSE)

spatreg ApSET2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSE)
 
spatreg ApSET3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPE_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSE)

}
}
*

 /*4.3. Modelos sobre la dependiente ApSC (Anthropogenic Print Spatail Contasction): */{

/*4.3.1.  1 lag Models*/{
spatreg ApSCT1 FMF1984_1991 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T1_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1 ApSC)

spatreg ApSCT2 FMF1992_1999 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T2_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1 ApSC)
 
spatreg ApSCT3 FMF1999_2006 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T3_lag1
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1 ApSC)
}

/*4.3.2.  1/2 lag Models*/{

spatreg ApSCT1 FMF1988_1995 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T1_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag1/2 ApSC)

spatreg ApSCT2 FMF1996_2003 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T2_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag1/2 ApSC)
 
spatreg ApSCT3 FMF2003_2010 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T3_lag12
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag1/2 ApSC)
}

/*4.3.3.  0 lag Models*/{

spatreg ApSCT1 FMF1992_1999 BonoDem BonoCuadrado PobUrb1992 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T1_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T1 lag0 ApSC)

spatreg ApSCT2 FMF2000_2007 BonoDem BonoCuadrado PobUrb2000 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T2_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T2 lag0 ApSC)
 
spatreg ApSCT3 FMF2007_2014 BonoDem BonoCuadrado PobUrb2007 logDistCAP PORCEDefores00_17, weights (W) eigenval(E) model (error)
est store AsPC_T3_lag0
estat ic
mat es_ic = r(S)
local AIC: display %4.1f es_ic[1,5]
local BIC : display %4.1f es_ic[1,6]
outreg2 using Resultados_ModelosEspaciales.xls, append excel dec(3) addstat(R-squared, e(sqCorr), AIC, `AIC', BIC, `BIC', Log-likelihood, e(ll)) ctitle (T3 lag0 ApSC)



est stats AAC_T1_lag1 AAC_T2_lag1 AAC_T3_lag1 AAC_T1_lag12 AAC_T2_lag12 AAC_T3_lag12 AAC_T1_lag0 AAC_T2_lag0 AAC_T3_lag0 AsPE_T1_lag1 AsPE_T2_lag1 AsPE_T3_lag1 AsPE_T1_lag12 AsPE_T2_lag12 AsPE_T3_lag12 AsPE_T1_lag0 AsPE_T2_lag0 AsPE_T3_lag0 AsPC_T1_lag1 AsPC_T2_lag1 AsPC_T3_lag1 AsPC_T1_lag12 AsPC_T2_lag12 AsPC_T3_lag12 AsPC_T1_lag0 AsPC_T2_lag0 AsPC_T3_lag0

}
}
}


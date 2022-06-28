/*
Exemplo 01 - Inclusão
========================================
DbSelectArea("SA1")
RecLock("SA1", .T.)	
SA1->A1_FILIAL := xFilial("SA1")	
SA1->A1_COD := "900001"	
SA1->A1_LOJA := "01"
MsUnLock() // Confirma e finaliza a operação

Exemplo 02 - Alteração
======================================
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek("01"+"900001"+"01")	
  RecLock("SA1", .F.)		
  SA1->A1_NOME := "CLIENTE TESTE"		
  SA1->A1_NREDUZ" := "TESTE"	
  MsUnLock() //Confirma e finaliza a operação
EndIf
*/
#Include 'Protheus.ch'

User Function xExecCli()

	Local aDados 	:= {}
	//Private lMsHelpAuto := .T.
	//Private lAutoErrNoFile := .T.
	Local lMsErroAuto 

	//Monta Array para Execução.
	aDados := {}
	Aadd(aDados,{"A1_FILIAL" 	,xFilial("SA1")		 	})
	Aadd(aDados,{"A1_COD"	 	,"000100"				})
	Aadd(aDados,{"A1_LOJA"	,"01"					})
	Aadd(aDados,{"A1_PESSOA" 	,"F"					})
	Aadd(aDados,{"A1_TIPO" 	,"F"					})
	Aadd(aDados,{"A1_NOME"	,"TESTE EXEC AUTO"		})
	Aadd(aDados,{"A1_NREDUZ" 	,"TESTE EXEC AUTO"		})
	Aadd(aDados,{"A1_END"	 	,"RUA EXEC"				})
	Aadd(aDados,{"A1_EST"	 	,"SP"					})
	Aadd(aDados,{"A1_MUN"		,"SAO PAULO"	})
	//Aadd(aDados,{"A1_COD_MUN"	,"35503"				})
	Aadd(aDados,{"A1_COD_MUN","50308"				})
	Aadd(aDados,{"A1_BAIRRO" 	,"TESTE"				})
	//Aadd(aDados,{"A1_CGC" 	,'12345678999'})
	Aadd(aDados,{"A1_CGC" 	,'51242349030'})
	
    lMsErroAuto := .F. 


	lMsExecAuto({|x,y| MATA030(x,y)}, aDados, 3)
	//2-Visualização
	//3-Inclusão
	//4-Alteração
	//5-Exclusão
	
	If lMsErroAuto
		MostraErro("\SYSTEM\LOG\",FUNNAME()+".LOG")
        MsgInfo("Não foi possível realizar o processo","Atenção!")
        DisarmTransaction() 
	EndIf
	
	MsgInfo("Processo finalizado")
return


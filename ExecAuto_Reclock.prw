#Include "Protheus.ch"

/*/{Protheus.doc} zGravacao
Exemplo de grava��o de dados via RecLock
/*/
User Function zAlterD()
    
    fExeAutMVC()
    fExecAuto()
    fRecLock()
    
Return    

static function fExeAutMVC()
    
    Local aArea      := GetArea()
    Local lDeuCerto  := .F.
    Local oModel 
    local oSA2Mode
	Local aErro      := {}
	
    // pegando o modelo de dados, setando a opera��o de inclus�o
    oModel := FWLoadModel("MATA020")
    oModel:SetOperation(3)
    oModel:Activate()

    //Pegando o model dos campos da SA2(isso aq foi copiado do YTB, precisa alterar para as do meu campo)
    oSA2Mode:= oModel:getModel("SA2MASTER")
    oSA2Mode:setValue("A2_COD",          "000001")
    oSA2Mode:setValue("A2_LOJA",          "01")
    oSA2Mode:setValue("A2_NOME",          "FORNEC MVC")
    oSA2Mode:setValue("A2_NREDUZ",          "MVC")
    oSA2Mode:setValue("A2_END",          "RUA TESTE")
    oSA2Mode:setValue("A2_BAIRRO",          "TESTE")
    oSA2Mode:setValue("A2_TIPO",          "J")
    oSA2Mode:setValue("A2_EST",          "SP")
    oSA2Mode:setValue("A2_COD_MUN",          "06003")
    oSA2Mode:setValue("A2_MUN",          "BAURU")
    oSA2Mode:setValue("A2_CGC",          "00000000000000")

    //Se conseguir validar as informa��es
    If oModel:VldData()

       //Tenta realizar o commit
       If oModel:CommitData()
          lDeuCerto := .T.
       //Se � deu certo, altera a vari�vel p false   
       else 
          lDeuCerto := .F.
        endif

    //Se � conseguir validar as informa�oes
    else 
       lDeuCerto := .F.
    Endif


    if ! lDeuCerto
        //Busca o Erro do modelo de dados
        aErro := oModel:GetErrorMessage()

        //Monta o Texto que ser� exibido na tela
        AutoGrLog("Id do formul�rio de origem:" +     ' [' + AllToChar(aErro[01]) + ']')
        AutoGrLog("Id do campo de origem:"      +     ' [' + AllToChar(aErro[02]) + ']')
        AutoGrLog("Id do formul�rio de erro:"   +     ' [' + AllToChar(aErro[03]) + ']')
        AutoGrLog("Id do campo de erro:"        +     ' [' + AllToChar(aErro[04]) + ']')
        AutoGrLog("Id do erro:"                 +     ' [' + AllToChar(aErro[05]) + ']')
        AutoGrLog("Mensagem de erro:"           +     ' [' + AllToChar(aErro[06]) + ']')
        AutoGrLog("Mensagem da solu��o:"        +     ' [' + AllToChar(aErro[07]) + ']')
        AutoGrLog("Valor atribu�do:"            +     ' [' + AllToChar(aErro[08]) + ']')
        AutoGrLog("Valor anterior:"             +     ' [' + AllToChar(aErro[09]) + ']')

        //Mostra a mensagem de Erro
        MostraErro()
    Endif

    //Desativa o modelo de dados
    oModel:DeActivate()

    RestArea(aArea)
Return

Static function fExecAuto()

    Local aArea := GetArea()
    Local aDados := {}
    Private lMsErroAuto := .F.

    //Adiciona os dados do cadastro de bancos
    Aadd(aDados,{"A6_COD"	 	,"000"				})
	Aadd(aDados,{"A6_AGENCIA"	,"00000"			})
	Aadd(aDados,{"A6_NUMCON" 	,"00000000000"		})
	Aadd(aDados,{"A6_NOME"	    ,"BANCO DE TESTE"	})

    //Iniciando transa��o
    Begin Transaction 
	    MsExecAuto({|x,y| MATA070(x,y)}, aDados, 3)

        //Se teve erro, mostre a mensagem
        if lMsErroAuto
           MostraErro()
           DisarmTransaction()
        else 
           MsgInfo("Banco 000 cadastrado com sucesso!", "Aten��o")
        endif
    End Transaction

    RestArea(aArea)

Return

static function fReclock()

    /*
    Exemplo 01 - Inclus�o
========================================
DbSelectArea("SA1")
RecLock("SA1", .T.)	
SA1->A1_FILIAL := xFilial("SA1")	
SA1->A1_COD := "900001"	
SA1->A1_LOJA := "01"
MsUnLock() // Confirma e finaliza a opera��o

Exemplo 02 - Altera��o
======================================
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek("01"+"900001"+"01")	
  RecLock("SA1", .F.)		
  SA1->A1_NOME := "CLIENTE TESTE"		
  SA1->A1_NREDUZ" := "TESTE"	
  MsUnLock() //Confirma e finaliza a opera��o
EndIf
*/

    local aArea    := GetArea()
    local cBanco   := "000"
    local cAgencia := "00000"
    local cConta   := "0000000000"
    local cNomeBco := "Banco Teste " +dToS(Date())

    //Selecionando a tabela de bancos
    DbSelectArea('SA6')
    SA6->(DbSetOrder(1)) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

    //Se conseguir posicionar no registro
    If SA6->(DbSeek( FWxFilial('SA6') + cBanco + cAgencia + cConta))

    //Atualizando o nome do banco
    RecLock('SA6', .F.)
       SA6->A6_NOME := cNomeBco
    SA6->(MsUnlock())
    endif

    RestArea(aArea)
return



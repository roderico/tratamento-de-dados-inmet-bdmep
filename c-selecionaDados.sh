#!/usr/bin/env bash

# Script para copiar do banco de dados BDMEP gerado pelo script B apenas
# as datas com os seguintes dados mínimos constantes:
# 
# 4: Altitude
# de 8 a 10: DirecaoVento;VelocidadeVentoMedia;VelocidadeVentoMaximaMedia
# 14: InsolacaoTotal
# 17: PrecipitacaoTotal
# de 20 a 23: TempMaximaMedia;TempCompensadaMedia;TempMinimaMedia;UmidadeRelativaMedia
# (cut, seu lindo! =D )

# Futuramente essas opções podem ser dadas na linha de comando:
# $ ./limpaDados.sh -1 -2 -3
# $ ./limpaDados.sh -2-12,16 


# Esse script está muito lerdo... =S
horaInic=$( date +%s)

header='Localidade;Latitude;Longitude;Altitude;Estacao;Data;Hora;DirecaoVento;VelocidadeVentoMedia;VelocidadeVentoMaximaMedia;EvaporacaoPiche;EvapoBHPotencial;EvapoBHReal;InsolacaoTotal;NebulosidadeMedia;NumDiasPrecipitacao;PrecipitacaoTotal;PressaoNivelMarMedia;PressaoMedia;TempMaximaMedia;TempCompensadaMedia;TempMinimaMedia;UmidadeRelativaMedia;VisibilidadeMedia'
zztrocaextensao=$( echo ~/BIN/scripts/funcoeszz zztrocaextensao )

###########################################
# Função selecionadora()
# A lista de arquivos:
selecionadora() {
	for DADOS in $( ls *.csv ); do
		numLINHAS=$( wc -l $DADOS | cut -f1 -d' ' )

	# A análise é feita linha por linha:
		for i in $( seq 1 $numLINHAS ); do
		# Esse passo é necessário, já que o sed não coloca o $header
		# na primeira linha sozinho... =S
			# echo >> $DADOS.texto
		# Mais variáveis:

			altitude=$( sed "$i!d" $DADOS | cut -f4 -d';' )
			direcaoVento=$( sed "$i!d" $DADOS | cut -f8 -d';' )
			velocidMediaVento=$( sed "$i!d" $DADOS | cut -f9 -d';' )
		#	velocidVentoMaxmedia=$( sed "$i!d" $DADOS | cut -f10 -d';' )
			# [ $( echo $velocidVentoMaxmedia | egrep '[0-9]') ] &&
			insolaTotal=$( sed "$i!d" $DADOS | cut -f14 -d';' )
			precipitaTotal=$( sed "$i!d" $DADOS | cut -f17 -d';' )
			tempMaxmedia=$( sed "$i!d" $DADOS | cut -f20 -d';' )
			tempCompensadaMedia=$( sed "$i!d" $DADOS | cut -f21 -d';' )
			tempMinimamedia=$( sed "$i!d" $DADOS | cut -f22 -d';' )
			umidadeRelativa=$( sed "$i!d" $DADOS | cut -f23 -d';' )
	
			[ $( echo $altitude | egrep '[0-9]') ] &&\
			[ $( echo $direcaoVento | egrep '[0-9]') ] &&\
			[ $( echo $velocidMediaVento | egrep '[0-9]') ] &&\
			[ $( echo $insolaTotal | egrep '[0-9]') ] &&\
			[ $( echo $precipitaTotal | egrep '[0-9]') ] &&\
			[ $( echo $tempMaxmedia | egrep '[0-9]') ] &&\
			[ $( echo $tempCompensadaMedia | egrep '[0-9]') ] &&\
			[ $( echo $tempMinimamedia | egrep '[0-9]') ] &&\
			[ $( echo $umidadeRelativa | egrep '[0-9]') ] &&\
			sed "$i!d" $DADOS >> $DADOS.texto
			# Forma anterior: sed "$i!d" $DADOS >> $DADOS.texto && echo "Linha $i foi escrita! =D" || echo "Faltou um dado aqui! Não escrevendo a linha $i!"
# Linhas de teste:
# Essa, fica como um pedaço do comandão ali de cima:
# echo OK || echo "Faltou um dado aqui! Não escrevendo!"

# Essa prá testar a variável $i
#	echo "Linha $i"

		done
		# Escreve $header na primeira linha
		sed -e '1i\' -e "$header" $DADOS.texto >> $DADOS.txt
		rm $DADOS.texto
		echo "Os dados do arquivo $DADOS foram escritos "
	done
# Remove os *csv anteriores (opção perigosa durante debug...)
	rm *csv
	bash -e $zztrocaextensao .csv.txt .csv *

} # Fim da função selecionadora()

####################################

# Para integrar com o script B:

for i in $( ls ); do
	if [ -d $i ];
		then echo "Entrando no diretório $i!"
		cd $i
		# executa a função selecionadora()
		selecionadora
		# Volta ao path inicial da execução
		cd ..
	else echo 'Fud...'
	fi
done


# Renomear com zz:


horaFinal=$( date +%s)
echo -e "Tempo de trabalho desse script:\n `expr $horaFinal \- $horaInic` segundos"
# Por fazer: mostrar em minutos ou horas... :3

exit 0

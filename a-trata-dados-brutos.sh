#!/usr/bin/env bash
# 
#########################################################################
#																		#
# NOME: 				A-GeraBD_inmet									#
# CRIADO EM:			19 de Junho de 2015 							#
# ULTIMA ATUALIZAÇÃO:	11 de Agosto de 2015							#
# AUTORE(S):	R. VALENTIN-DE-SOUZA <superantigo (a) gmail.com>		#
# DEPENDÊNCIA(S):		funçõeszz ( http://funcoeszz.net )				#
######## DESCRIÇÃO ######################################################
#																		#
# Limpeza dos dados obtidos no BDMEP - INMET 							#
# 	http://www.inmet.gov.br/projetos/rede/pesquisa/						#
#																		#
#																		#
#########################################################################
# Copyright 2015 Rodrigo Leite Valentin de Souza						#
#  <superantigo (a) gmail.com>											#
#              															#
# LICENÇA    : GPLv2													#
#																		#
#  																		#
#  This program is free software; you can redistribute it and/or modify	#
#  it under the terms of the GNU General Public License as published by	#
#  the Free Software Foundation; either version 2 of the License, or	#
#  (at your option) any later version.									#
#  																		#
#  This program is distributed in the hope that it will be useful,		#
#  but WITHOUT ANY WARRANTY; without even the implied warranty of		#
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		#
#  GNU General Public License for more details.							#
#  																		#
#  You should have received a copy of the GNU General Public License	#
#  along with this program; if not, write to the Free Software			#
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,			#
#  MA 02110-1301, USA.													#
#																		#
# CHANGELOG  : <superantigo (a) gmail.com>								#
#																		#
# 0.1 (19 de Junho de 2015):											#
#	-Limpeza dos cabeçalhos e lixo no final do(s) arquivo(s).			#
# 1.0 (11 de Agosto de 2015):											#
#	-Recodificação dos arquivos para o formato do sistema (UTF-8)		#
#	-Uso de zzfuncoes para corrigir vários pequenos detalhes dos		#
#	arquivos orginais do site (nome, linhas vazias, extensão html... )	#
#########################################################################
#  zzfuncoes: "O" script.
zzlimpalixo=$( echo ~/BIN/scripts/funcoeszz zzlimpalixo )
zztrocaextensao=$( echo ~/BIN/scripts/funcoeszz zztrocaextensao )

# Apaga linhas em branco e comentários.
bash -e $zzlimpalixo *.txt 

#  Tira acento, cedilha, substitui espaço por underline
bash -e $zzarrumanome *.txt

# Auto-explicativo. Alguns arquivos, ao serem baixados do site
# podem acabar com a extensão html
bash -e $zztrocaextensao .html .txt * 

# FUNÇÃO RECODIFICA
# testando se os arquivos são UTF-8. Se não são,
# o script tenta recodificar.
# com base no primeiro arquivo da listagem de arquivos. 
# tr trocará caixas baixas por altas
recodifica() {
	echo "A codificação de caracteres do arquivo não está adequada." && sleep 1;
	echo "A codificação para o correto funcionamento do script é UTF-8, porém"
	echo "os arquivos estão em $codificacao" && sleep 1;
	echo "Iniciando a tentativa de recodificação" && sleep 1;
	for arq in $( ls *.txt ); do
	# iconv recodifica de praticamente qualquer codificação para UTF-8:
	iconv  $arq -f $codificacao -t UTF-8 -o UTF8-$arq
	done
	rm [^UTF8]*.txt # remove todos EXCETO UTF-8
	echo "Mudança da codificação dos arquivos de texto finalizada"
}

# Preciso extrair o tipo exato de codificação de ao menos um arquivo:
codificacao=$( file -i *.txt | head -n 1 | cut -f2 -d'=' | tr [:lower:] [:upper:] )

# Testa o tipo de codificação:
if [ "$codificacao" != 'UTF-8' ]; then
	recodifica # chama a função recodifica() 
else echo "Codificação dos arquivos"
fi

numArqs=$( ls *.txt -1 | wc -l )
# contador=1
count=0
	for i in $( ls *.txt -1 ); # lista os arquivos no diretório 
# atual, 1 por linha ( ls -1 ) e conta quantas linhas isso deu ( wc -l ); e 
#envia o resultado para o seq, para alimentar o for
	do
	# Aqui começa a magia: o cut precisa do $ no delimitador para ser utilizado
	# com caracteres não-imprimíveis ('\t' || '\n' etc). 
		Lista[$count]=$i
#		echo "${Lista[$count]}"
# Daqui prá cima: OK

		# CABEÇALHO DO BDMEP - INMET
	
		# ${Lista[$count]} é o nome do arquivo.
	
  		cabecalho=$( sed -n '/INMET/,/dados/p' ${Lista[$count]} )
  		
		# Início do comentário multilinha (usei para debug):
  		# : <<'fimDoComent'
  		# LOCALIDADE=$( echo $cabecalho | cut -f4 -d' ' ) # Recorte da Localidade


		# Código da Estação. Não está em uso para manter a compatibilidade com
		# o restante dos scripts.
		# codigoEstacao=$( echo $cabecalho | cut -f2 -d'(' | cut -f1 -d')' )
#  		echo "Código da Est: $codigoEstacao"


  		LOCALIDADE=$( echo $cabecalho | cut -f1 -d'(' | cut -f2 -d':' )
		# LOCALIDADE=$( echo $texto | sed '/Estação/{p;q;}' ) # Solução anterior
#		echo " Localidade: $LOCALIDADE"
		# Latitude
		# LATITUDE=$( echo $texto | fgrep Latitude | cut -f2 -d':' ) # Solução anterior
		LATITUDE=$( echo $cabecalho | cut -f2,3 -d')' | cut -f2 -d':' | cut -f2 -d' ' )
#		echo "Latitude: $LATITUDE"
		# Longitude

		# LONGITUDE=$( echo $texto | fgrep Longitude | cut -f2 -d':' ) # Solução anterior
		LONGITUDE=$( echo $cabecalho | cut -f5 -d':' | cut -f2 -d' ' )
#		echo "Longitude: $LONGITUDE"
		# Altitude
		# ALTITUDE=$( echo $texto | fgrep Altitude | cut -f2 -d':' ) # Solução anterior
		ALTITUDE=$( echo $cabecalho | cut -f6 -d':' | cut -f2 -d' ' )
#		echo "Altitude: $ALTITUDE"
################ FIM DO CABEÇALHO #############
	# tr: apaga os 'tab' do arquivo
	# Primeiro sed: seleciona tudo ENTRE VisibilidadeMedia e Fechar INCLUSIVE: sed  -n '/Estacao/,/Fechar/p'
	# Segundo sed: apaga TODAS as linhas em branco: sed '/^$/d'
	# Terceiro sed: apaga da linha [Fechar] em diante (deveria...):  sed 's/Fechar.*$//'
	# Quarto sed: Apaga tag pre>
	# Quinto sed: Apaga a linha de cabeçalho dos dados.
		texto=$( cat -sE ${Lista[$count]} | tr -d '\t' | sed  -n '/VisibilidadeMedia;/,/Fechar/p' | sed '/^$/d' |sed 's/Fechar.*$//' | sed '/pre>/d' | sed '/VisibilidadeMedia/d' | tr -d '[') 
	# Esse comando escreve essas 4 variáveis ($LOCALIDADE;$LATITUDE;$LONGITUDE;$ALTITUDE)
	# repetidamente no arquivo, até o fim.
	
		# 
		echo $texto | tr '$' '\n' | tr '.' ',' | sed  "s/^/$LOCALIDADE;$LATITUDE;$LONGITUDE;$ALTITUDE;/" >> ${Lista[$count]}2

# Abaixo o fim do "comentário" multilinha:
# fimDoComent
		let count++

	done # fim do for

# Para fins de debug:
#	echo "${#Lista[@]} itens" # número de itens
#	echo ${Lista[@]} # mostra os itens em si.

##########################
cat *txt2 >> BaseDeDados.txt
rm *txt2
mkdir BDMEP-inmet
mv [^BaseDeDados]*.txt BDMEP-inmet
exit 0

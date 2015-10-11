# tratamento-de-dados-inmet-bdmep
Shell Scripts para limpeza de dados dos arquivos gerados pelo site inmet-bdmep de meteorologia (pt-br)
São scripts que fazem mais sentido quando se trabalha com quantidade brutal de dados do bdmep.

Eles AINDA NÃO ESTÃO INTEGRADOS ENTRE SI!

Script A: recodifica do formato do site para UTF-8 (se não estiver ainda nesse formato) usando o iconv.
Depois ele coloca os dados de Nome da Localidade/Lat/Long/Altit na frente dos dados do arquivo, repetidamente em todas as linhas.
Depois apaga linhas em branco e tags ("lixo") e gera um único arquivo de banco de dados a partir de TODOS os arquivos *txt do diretório atual.

Script B: A partir do banco de dados gerado no script A, agora serão gerados os CSV por mês. Ele está "estático" nos meses gerados, desejável que no futuro não seja assim.
Depois cria diretórios segundo os anos digitados pelo utilizador e envia os CSVs para seus respectivos anos.

Script C: Seleciona dos CSVs apenas as datas que possuem os dados X/Y/Z. Exemplo: se não possui Precipitação Total, aquela data daquela estação NÃO SERÁ copiada para o novo CSV. Por enquanto está "estático". Seria melhor no futuro esse passo estar no Script B.
Depois coloca o cabeçalho original no topo do arquivo.
O controle de tempo de execução desse script é porque na 1ª execução que fiz dele, demorou mais de 4 horas (bastante arquivos; mesmo assim estava lento demais). Porém fiz modificação que pode ser que torne esse controle inútil no futuro.

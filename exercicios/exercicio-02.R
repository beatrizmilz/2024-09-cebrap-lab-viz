# Carregar o pacote tidyverse

library(tidyverse)

# IMPORTAÇÃO -------------------------------------------------------------------
# Importar os dados que iremos usar
dados_pnud <- read_csv2("dados/base_pnud_min.csv")

# PREPARANDO OS DADOS:
# Nesse exercício, escolhi criar um gráfico diferente 
# dos usados nas aulas.

# Queremos representar no gráfico os 
# municípios cujo tiveram maior e menor aumento absoluto
# de esperança de vida ao longo do tempo.

# Esse gráfico requer mais manipulação de dados,
# e menos código de ggplot2 em si.

# Preparei a manipulação, e deixei comentários.
# O exercício consiste em usar o gráfico criado (exploratório)
# e transformar ele em um gráfico para apresentar.


dados_formato_largo <- dados_pnud |>
  select(ano, muni_nm, uf_sigla, espvida) |>
  pivot_wider(names_from = ano,
              values_from = espvida,
              names_prefix = "espvida_")  |>
  mutate(diferenca_inicio_fim = espvida_2010 - espvida_1991) |>
  arrange(desc(diferenca_inicio_fim))

maiores_crescimentos <- dados_formato_largo |>
  slice_head(n = 5) |>
  mutate(categoria = "Maior aumento")

menores_crescimentos <- dados_formato_largo |>
  slice_tail(n = 5) |>
  mutate(categoria = "Menor aumento")

tabela_final <-
  bind_rows(maiores_crescimentos, menores_crescimentos) |>
  pivot_longer(
    cols = starts_with("espvida_"),
    names_prefix = "espvida_",
    names_to = "ano",
    values_to = "espvida"
  ) |>
  mutate(ano = as.numeric(ano),
         categoria = fct_relevel(categoria,
                                 c("Menor aumento", "Maior aumento")))


grafico_base <- tabela_final |>
  ggplot() +
  aes(x = ano, y = espvida) +
  geom_line(aes(group = muni_nm, color = categoria), alpha = 0.7) +
  geom_point(aes(color = categoria)) + 
  facet_wrap(~categoria)

# EXERCÍCIO 1 -------------------------------------------
# Usando o objeto grafico_base:
grafico_base

# Vamos usar funções da aula passada para deixar ele mais 
# próximo de ser apresentado. 
# Caso não consiga fazer alguma das etapas,
# pule para a próxima

grafico_base # +
# Use algum tema
  
# Adicione os textos dos eixos
# adicione um título, subtitulo, fonte

# Altere a escala de cores
  
# tente deixar a legenda abaixo do gráfico


# Faça modificações que achar necessário,
# e anote caso não consiga fazer alguma delas

# Salve o gráfico em um objeto no R,
# e então salve localmente no seu computador.




# EXERCÍCIO 2 -------------------------------------------

# Volte no código de manipulação.
# tente entender o que acontece em cada etapa.
# Sugiro executar o código linha a linha para ver o que está
# acontecendo, e deixar comentários.

# Revisaremos na aula :)
# Introdução ao pacote ggplot2

# https://ggplot2.tidyverse.org/
# Pacote faz parte do tidyverse:
# https://www.tidyverse.org/

# Quando instalamos ou carregamos o tidyverse, o ggplot2 também é instalado/carregado.


# Instalar pacote: (lembrando que apenas precisamos fazer isso uma vez)
# install.packages("tidyverse")

# Carregar pacote: (precisamos fazer isso toda vez que iniciamos o R)
# Dica: colocar no início do script
library(tidyverse)

# IMPORTAÇÃO -------------------------------------------------------------------
# Importar os dados que iremos usar
dados_pnud <- read_csv2("dados/base_pnud_min.csv")

# ver as colunas
glimpse(dados_pnud)
# Rows: 16,686
# Columns: 15
# $ ano       <dbl> 1991, 1991, 1991, 1991, 1991, 1991, 1991, 1991, 199…
# $ muni_id   <dbl> 1100015, 1100023, 1100031, 1100049, 1100056, 110006…
# $ muni_nm   <chr> "ALTA FLORESTA D'OESTE", "ARIQUEMES", "CABIXI", "CA…
# $ uf_sigla  <chr> "RO", "RO", "RO", "RO", "RO", "RO", "RO", "RO", "RO…
# $ regiao_nm <chr> "Norte", "Norte", "Norte", "Norte", "Norte", "Norte…
# $ idhm      <dbl> 0.329, 0.432, 0.309, 0.407, 0.386, 0.376, 0.203, 0.…
# $ idhm_e    <dbl> 0.112, 0.199, 0.108, 0.171, 0.167, 0.151, 0.039, 0.…
# $ idhm_l    <dbl> 0.617, 0.684, 0.636, 0.667, 0.629, 0.658, 0.572, 0.…
# $ idhm_r    <dbl> 0.516, 0.593, 0.430, 0.593, 0.547, 0.536, 0.373, 0.…
# $ espvida   <dbl> 62.01, 66.02, 63.16, 65.03, 62.73, 64.46, 59.32, 62…
# $ rdpc      <dbl> 198.46, 319.47, 116.38, 320.24, 240.10, 224.82, 81.…
# $ gini      <dbl> 0.63, 0.57, 0.70, 0.66, 0.60, 0.62, 0.59, 0.65, 0.6…
# $ pop       <dbl> 22835, 55018, 5846, 66534, 19030, 25070, 10737, 690…
# $ lat       <dbl> -11.929, -9.913, -13.492, -11.438, -13.189, -13.117…
# $ lon       <dbl> -61.996, -63.041, -60.545, -61.448, -60.812, -60.54…

dados_pnud_2010 <- dados_pnud |>
  filter(ano == 2010)


# Importar o dicionário de dados
dicionario_pnud <- read_csv2("dados/dicionario_base_pnud_min.csv")

# ver as colunas
glimpse(dicionario_pnud)

# Primeiros passos com o ggplot2 -------
# Nesta aula, focaremos em criar visualizações EXPLORATÓRIAS

# A função ggplot() cria um objeto gráfico vazio
dados_pnud_2010 |>
  ggplot()

# A partir da função ggplot, não usamos mais o pipe (%>% ou |>), e sim o +
# Estamos somando "camadas" ao gráfico.



# A função aes() define o mapeamento estético (aesthetics mapping) 
# entre as colunas
# da base de dados (variáveis) e os elementos visuais do gráfico
# (eixo, posição, cor, tamanho, etc)

# Exemplo:
# atribuimos para o eixo x a coluna idhm e para o eixo y a coluna espvida
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida)

# Para adicionar um elemento geométrico ao gráfico, usamos alguma
#  função da família geom_*

# Exemplo: scatter plot, ou gráfico de dispersão, ou gráfico de pontos

# A função geom_point() adiciona pontos ao gráfico
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point()


# A função geom_smooth() adiciona uma linha de tendência ao gráfico
# neste exemplo, usamos o método de regressão linear (lm) - linear model
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)


# A partir deste exemplo, o que podemos listar de pontos importantes sobre o ggplot2?

# 1. A função ggplot() cria um objeto gráfico vazio

# 2. Podemos usar o pipe (%>% ou |>) para encadear as funções ATÉ a função ggplot()

# 3. A partir da função ggplot, não usamos mais o pipe (%>% ou |>), e sim o +

# 4. A função aes() define o mapeamento estético (aesthetics mapping) entre as colunas
# da base de dados (variáveis) e os elementos visuais do gráfico
# (eixo, posição, cor, tamanho, etc)

# 5. Os atributos estéticos (aes) x e y representam os eixos x e y do gráfico

# 6. Para adicionar um elemento geométrico ao gráfico, usamos alguma
#  função da família geom_*

# 7. A função geom_point() adiciona pontos ao gráfico

# 8. A função geom_smooth() adiciona uma linha de tendência ao gráfico

# 9. Podemos usar mais do que uma geometria no mesmo gráfico, e a ordem importa!

# AES --------------------------------------------------------------------------
# Explorando outros atributos estéticos!

# Atributo estético: cor (color)

# Exemplo: vamos colorir os pontos de acordo com a região do Brasil

dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point(aes(color = regiao_nm))

# Atributo estético: tamanho (size)

# Exemplo: vamos aumentar o tamanho dos pontos de acordo com a população

dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point(aes(size = pop))

# Atributo estético: forma (shape)

# Exemplo: vamos mudar a forma dos pontos de acordo com a região do Brasil

dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point(aes(shape = regiao_nm))

# Atributo estético: transparência (alpha)

# Exemplo: vamos deixar os pontos mais transparentes

dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm, y = espvida) +
  geom_point(alpha = 0.5)

# Atributo estético: preenchimento (fill)
# No tipo de gráfico que estamos explorando (geom_point), não faz sentido usar preenchimento
# Mas vamos ver um exemplo com outro tipo de gráfico, logo logo!


# Atributo estético: linetype
# No tipo de gráfico que estamos explorando (geom_point), não faz sentido usar linetype
# Mas vamos ver um exemplo com outro tipo de gráfico, logo logo!



# EXPLORANDO OUTRAS GEOMETRIAS -------------------------------------------------
# Gráfico de barras (geom_col) -------------------------------------------------

# Muitas vezes precisamos preparar os dados antes de iniciar o ggplot


# Exemplo: vamos criar um gráfico de barras com a média do IDHM por região e UF
# Primeiro vamos preparar a base de dados para colocar no gráfico
media_idhm_por_regiao <- dados_pnud_2010 |>
  group_by(regiao_nm, uf_sigla) |>
  summarise(media_idhm = mean(idhm))

# Podemos criar o gráfico de barras usando o geom_col

media_idhm_por_regiao |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col()

# O gráfico por padrão fica com colunas ordenadas em ordem alfabética
# Veremos como mudar isso em breve! Dica: isso faz parte da preparação dos dados,
# antes de iniciar o ggplot

# Usando o aes() fill, podemos colorir as barras de acordo com alguma coluna da
# base (nesse caso, a região)
media_idhm_por_regiao |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col(aes(fill = regiao_nm))

# Podemos criar vários gráficos em um, usando o facet_wrap()
media_idhm_por_regiao |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col(aes(fill = regiao_nm)) +
  facet_wrap(~regiao_nm, scales = "free_y")

# veremos mais exemplos de facet ao longo das aulas!

# Gráfico de linhas (geom_line) -------------------------------------------------

# O gráfico de linhas é muito usado para visualizar séries temporais
# Vamos usar os dados_pnud, que contém dados de 1991, 2000 e 2010

# Primeiro vamos preparar a base de dados para colocar no gráfico

dados_idhm_ano_regiao <- dados_pnud |>
  dplyr::group_by(ano, regiao_nm) |>
  summarise(media_idhm = mean(idhm))


# Podemos criar o gráfico de linhas usando o geom_line

dados_idhm_ano_regiao |>
  ggplot() +
  aes(x = ano, y = media_idhm) +
  geom_line(aes(color = regiao_nm))

# Usando o aes() linetype, podemos mudar o tipo de linha

dados_idhm_ano_regiao |>
  ggplot() +
  aes(x = ano, y = media_idhm) +
  geom_line(aes(color = regiao_nm), linetype = "dashed")

# PAUSA PARA REVISÃO DE CONCEITO!
# Pq o linetype ficou fora do aes()?
# Colocamos dentro do aes() apenas o que varia de acordo com a base de dados
# No caso, a cor varia de acordo com a região, mas o tipo de linha não varia
# de acordo com a base de dados, então colocamos fora do aes().
# Se quisermos que cada região tenha um tipo de linha, aí sim poderíamos
# colocar o linetype dentro do aes(). Por exemplo:

dados_idhm_ano_regiao |>
  ggplot() +
  aes(x = ano, y = media_idhm) +
  geom_line(aes(color = regiao_nm, linetype = regiao_nm))


# Gráfico histograma (geom_histogram) -------------------------------------------------

# O gráfico histograma é muito usado para visualizar a distribuição de uma variável
# Portanto, não faz sentido usar no aes() o eixo y, pois não temos duas variáveis

# Podemos visualizar a distribuição dos valores de IDHM
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm) +
  geom_histogram()

# Podemos mudar o número de bins (caixas) do histograma
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm) +
  geom_histogram(bins = 10)

# Podemos mudar a cor das caixas do histograma
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm) +
  geom_histogram(bins = 10, fill = "lightblue")

# Podemos mudar a cor das bordas das caixas do histograma
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm) +
  geom_histogram(bins = 10, fill = "lightblue", color = "black")

# Outra geometria similar é o geom_density
# A diferença é que o geom_density é uma curva, e o geom_histogram são caixas
dados_pnud_2010 |>
  ggplot() +
  aes(x = idhm) +
  geom_density(fill = "lightblue", color = "black")

# Gráfico de boxplot (geom_boxplot) -------------------------------------------------

# O gráfico de boxplot é muito usado para visualizar a distribuição de uma variável
# Mas a interpretacao é diferente do histograma
# No boxplot, temos a mediana (linha preta central), o primeiro quartil (linha inferior da caixa),
# o terceiro quartil (linha superior da caixa), e os outliers (pontos)
# Os outliers são conhecidos também como "pontos fora da curva", ou valores extremos

# Sugestão de leitura:
# https://escoladedados.org/tutoriais/analise-com-estatistica-descritiva-para-leigos/
# https://fernandafperes.com.br/blog/interpretacao-boxplot/


# Podemos visualizar a distribuição dos valores de esperança de vida por região
dados_pnud_2010 |>
  ggplot() +
  aes(x = regiao_nm, y = espvida) +
  geom_boxplot()


# Podemos mudar a cor das caixas do boxplot
dados_pnud_2010 |>
  ggplot() +
  aes(x = regiao_nm, y = espvida) +
  geom_boxplot(fill = "lightblue", color = "black")

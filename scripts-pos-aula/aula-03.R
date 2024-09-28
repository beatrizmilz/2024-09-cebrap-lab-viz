# Mapas com ggplot2 -----------------------

## Carregar pacotes

library(sf)
library(geobr)
library(tidyverse)
library(abjData)


# Pacote sf

# O pacote {sf} (Simple Features for R) (Pebesma 2020, 2018)
# possibilita trabalhar com bases de dados espaciais.

# Para utilizar esses dados, temos duas abordagens:
# - Bases que não são georreferenciadas
#  - Bases que são georreferenciadas


## Trabalhando com bases não georreferenciadas -----------------------------------

# Identificar a unidade de análise, e com os joins,
# unir com uma base georreferenciada.

# O pacote **geobr** (Pereira and Goncalves 2020) é um pacote que
# disponibiliza funções para realizar o download de diversas bases de
# dados espaciais oficiais do Brasil. Você pode saber mais no repositório do
#  pacote no GitHub: https://ipeagit.github.io/geobr/

## Datasets do Brasil ----------------------

# Quais funções para acessar cada dataset: `geobr::list_geobr()`

# geobr::list_geobr()

list_geobr() |> View()

# cuidado com o View()

# mudar o sistema de refencias
# sf::st_set_crs()
# Exemplos:


# geobr::read_country() # importa a delimitação do Brasil

brasil <- read_country()

glimpse(brasil)


brasil |> 
  ggplot() + 
  geom_sf()

# geobr::read_state() # importa a delimitação dos estados do Brasil

estados <- read_state()

glimpse(estados)

estados |> 
  ggplot() +
  geom_sf(aes(fill = name_region))


mg <- read_state("MG")

mg |> 
  ggplot() +
  geom_sf()

# geobr::read_state("DF") # importa a delimitação de um Estado específico,
#  usando a sigla

# geobr::read_municipality() # importa a delimitação de todos os municípios
#  do Brasil. É uma base mais pesada!

# geobr::read_municipality(code_muni = 3550308) # importa a delimitação
# de um município específico, usando o código do IBGE do município.


muni_sp <- read_municipality("SP")

glimpse(muni_sp)


osasco <- read_municipality(code_muni = 3534401)
sp <- read_state("SP")

osasco |> 
  ggplot() +
  geom_sf()


# Podemos usar esses diferentes objetos como camadas do gráfico ----

ggplot() +
# geom_sf(data = estados, color = "gray") +
  geom_sf(data = sp, color = "blue") +
  geom_sf(data = muni_sp) + 
  geom_sf(data = osasco, color = "red", fill = "red")



# pausa para o join!!!

library(dados)
pixar_filmes |> View() 
pixar_bilheteria |> View()

pixar_join <- full_join(pixar_filmes, pixar_bilheteria, by = "filme")

# voltar, join com base_pnud_min
# vamos fazer a união
base_pnud_min <- read_csv2("dados/base_pnud_min.csv")

muni_sp <- read_municipality("SP")

muni_sp_geo <- muni_sp |> 
  left_join(base_pnud_min, by = c("code_muni" = "muni_id"))


sf::write_sf(muni_sp_geo, "output/pnud_min_sp.shp")


glimpse(muni_sp_geo)

muni_sp_geo |> 
  ggplot() +
  geom_sf(aes(fill = espvida)) +
  facet_wrap(vars(ano)) +
  scale_fill_viridis_c() +
 # theme_void()
  theme_bw()


## Exemplo 1: Trabalhando com os estados brasileiros ------------------

### Importar as bases

# Não usar View()!

# Delimitação dos Estados:

# a) Todos os estados do Brasil

estados <- readr::read_rds("dados/geobr/estados.Rds")

# Como obter essa mesma base?
# estados <- geobr::read_state()



# b) Apenas um estado: DF


estado_df <- readr::read_rds("dados/geobr/estado_df.Rds")

# Como obter essa mesma base?
# estado_df <- geobr::read_state("DF")



### Explorar os dados

# Qual é a classe?
class(estados)



# Usamos o pacote ggplot2 para criar os mapas, utilizando o geom_sf()

estados %>%
  ggplot() +
  geom_sf()


# Empilhando as bases usando os geom's :


ggplot() +
  geom_sf(data = estados) +
  geom_sf(data = estado_df, fill = "blue") +
  theme_bw()



### Usando o dplyr com objetos sf

# - glimpse() - observar o que a base contém


glimpse(estados)




# - filter() - conseguimos filtrar os objetos


estados %>%
  filter(name_region == "Nordeste") %>%
  ggplot() +
  geom_sf()



# - join()


class(abjData::pnud_uf)

# quando for fazer join, usar primeiro a base que tem
# a coluna geom (a base de classe sf)



pnud_uf_sf <- estados %>%
  left_join(abjData::pnud_uf, by = c("code_state" = "uf"))

class(pnud_uf_sf)



### Mapas temáticos ------------------------


# glimpse(pnud_uf_sf)

pnud_uf_sf %>%
  filter(ano == 2010) |> 
  ggplot(aes(fill = idhm)) +
  geom_sf() +
  theme_void()



## Exemplo 2: Escolas em Brasília, DF -----

### Carregar os dados usados

# a) Escolas em Brasília

# escolas_brasilia <- readr::read_rds("dados/geobr/escolas_brasilia.Rds")

# Como obter essa mesma base?
escolas <- read_schools()

escolas_brasilia <- escolas |> 
  filter(abbrev_state == "DF", name_muni == "Brasília")

glimpse(escolas_brasilia)


# b) Delimitação de Brasília


# municipio_brasilia <- readr::read_rds("dados/geobr/municipio_brasilia.Rds")

# Como obter essa mesma base?
municipio_brasilia <- read_municipality(5300108)



### Fazer um mapa!

# Passo 1: colocar a delimitação do município e também as escolas


ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia)


# Passo 2: Colorir as escolas por "government_level"


ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level))


# regioes administrativas - buscar

limite_ra_2019 <- sf::read_sf("dados/Limite_RA_2019/Limite_RA_2019.shp")

ggplot() +
  geom_sf(data = limite_ra_2019)

ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = limite_ra_2019) +
  geom_sf(data = escolas_brasilia, aes(color = government_level))



# Passo 3: Fazer um facet com "government_level"

ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = limite_ra_2019) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) +
  facet_wrap(~government_level, ncol = 1)


ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) +
  facet_wrap(~government_level)



# Passo 4: Remover a legenda, mudar o tema, adicionar um título e
# centralizar o título

gghighlight::gghighlight()

ggplot(data = limite_ra_2019) +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = limite_ra_2019) +
  # gghighlight destaca, mas não nomeia
  gghighlight::gghighlight(ra == "Paranoá") +
  geom_sf(data = escolas_brasilia, aes(color = government_level)) +
  facet_wrap(~government_level, ncol = 1) +
  theme_void() +
  labs(title = "Escolas em Brasília \n") +
  theme(plot.title = element_text(hjust = 0.5)) 




ggplot() +
  geom_sf(data = municipio_brasilia) +
  geom_sf(data = escolas_brasilia, aes(color = government_level), show.legend = FALSE) +
  facet_wrap(~government_level) +
  theme_void() +
  labs(title = "Escolas em Brasília \n") +
  theme(plot.title = element_text(hjust = 0.5))




# Exemplo 3 - Rodovias em DF --------------

### Carregar os pacotes


library(sf)
library(geobr)
library(magrittr)



# Como buscar a base? Se quiser baixar, remova os comentários (#) dos códigos abaixo:



# Link que disponibiliza a base
# u_shp <- "https://www.gov.br/infraestrutura/pt-br/centrais-de-conteudo/rodovias-zip"

# Cirar a pasta para baixar o arquivo
# dir.create("../dados/shp_rod")

# Fazer o download do arquivo zip
# httr::GET(u_shp,
#           httr::write_disk("../dados/shp_rod/rodovias.zip"),
#           httr::progress())

# Descompactar o zip
# unzip("../dados/shp_rod/rodovias.zip", exdir = "../dados/shp_rod/")


# Importar a base em arquivo .shp
# rodovias <-
#   st_read(
#     "../dados/shp_rod/rodovias.shp",
#     quiet = TRUE#,
#     #options = "ENCODING=WINDOWS-1252"
#   ) %>%
#   # limpar o nome das colunas
#   janitor::clean_names()

# filtrar para DF

# rodovias_df <- rodovias %>%
#   filter(sg_uf == "DF")




### Importar a base

# Essa base foi gerada a partir do código no chunk anterior.


rodovias_df <- readr::read_rds("dados/rodovias_df.Rds")



### Fazendo um mapa simples


ggplot() +
  geom_sf(data = rodovias_df, aes(color = ds_legenda))




## Juntar os 3 exemplos!


# Inicio do ggplot
ggplot() +
  # limite do estado
  geom_sf(data = limite_ra_2019, fill = "white") + 
 # geom_sf(data = estado_df, color = "gray") +
  # escolas
  geom_sf(data = escolas_brasilia, aes(color = government_level), alpha = 0.5
          ) +
  # rodovias
  geom_sf(data = rodovias_df, aes(color = ds_legenda)) +
  # adicionar tema
  theme_void()




# Praticar com os dados do abjData :)
# Turma sugerir algum mapa para fazer com os dados do abjData
# que já estamos usando no curso!

library(tidyverse)
library(sf)
library(geobr)

dados_pnud <- read_csv2("dados/base_pnud_min.csv")

dados_pnud_2010 <- dados_pnud |>
  filter(ano == 2010)


# pontos - com lat/lon da base
dados_pnud_2010 |> 
  filter(uf_sigla == "SP") |> 
  # cria a coluna geom baseado nas colunas lat/lon
  st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4674") |> 
  ggplot() +
  geom_sf(data = muni_sp) + 
  geom_sf(aes(color = espvida), alpha = 1)


# Como buscar dados de outros países?

library(geodata)

# cria diretorio temporario
temporary_dir <- fs::path_temp()
temporary_dir

data_world <- geodata::world(path = temporary_dir)

data_world_sf <- data_world |>
  sf::st_as_sf()

glimpse(data_world_sf)

data_world_sf_colorir <- data_world_sf |> 
  mutate(regiao = case_when(
    NAME_0 %in% c("Brazil", "Argentina", "Paraguay",
                  "Uruguay") ~ "Mercosul" 
  ))

ggplot() +
  geom_sf(data = data_world_sf_colorir, aes(fill = regiao))



data_world_sf_colorir <- data_world_sf |> 
  mutate(regiao = case_when(
    NAME_0 %in% c("Brazil", "Argentina", "Paraguay", "Uruguay") ~ "Mercosur")) |> 
  ggplot() +
  geom_sf(data = data_world_sf_colorir, aes(fill = regiao))



# Como abrir arquivos externos, como shapefiles ou geopackages? ----

# ler shapefile, ou geopackage
# sf::read_sf("arquivo.shp")
# escrever um geopackage
# sf::write_sf("nome_arquivo.gpkg")



# lendo o arquivo que criamos anteriormente!
library(sf)
pnud_min <- read_sf("output/pnud_min_sp.shp")





# Abrindo shape
# https://transparencia.metrosp.com.br/dataset/pesquisa-origem-e-destino
od97 <- sf::read_sf(
"~/Downloads/Pesquisa Origem Destino 1977/Mapas/Shape/Zonas1977_region.shp"
)

od97 |> 
  ggplot() +
  geom_sf()



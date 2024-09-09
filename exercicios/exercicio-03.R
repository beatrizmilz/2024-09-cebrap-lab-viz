# mapas com ggplot2

# Usando os dados do sigbm (que vimos na aula 1):
# Importação ----

# importar dados baixados
sigbm_bruto <- readxl::read_xlsx("dados/sigbm_20245408.xlsx", skip = 4) 

# Organização dos dados

sigbm <- sigbm_bruto |> 
  janitor::clean_names() |> 
  # arrumar as coordenadas lat/lon 
  # de graus/min/seg para graus decimais
  dplyr::mutate(lat = parzer::parse_lat(latitude),
                long = parzer::parse_lon(longitude)) |> 
  # mudar para formato sf
  sf::st_as_sf(coords = c("long", "lat"))

## Exercicio 1: praticando com ggplot2

# Crie um mapa com as barragens de mineração
# presentes no seu estado.
# Caso não tenha nenhuma no seu estado,
# utilize algum outro para fazer o exemplo.

# Adicione os pontos das barragens, e também a delimitação do estado.

# Explore os dados e escolha alguma variável para apresentar na coloração 
# dos pontos que você ache interessante





# Exercício 2: otimização visual

# Otimize o mapa criado acima de forma que você ache que fique melhor
# para ser apresentado!






## Exemplo de mapa com leaflet -----------------------

sigbm |>
  dplyr::mutate(texto_label = paste0(nome_da_barragem, " - ", nome_do_empreendedor)) |> 
  leaflet::leaflet() |>
  leaflet::addProviderTiles("Esri.WorldImagery") |>
  leaflet::addMarkers(label = ~texto_label,
                       clusterOptions = leaflet::markerClusterOptions())






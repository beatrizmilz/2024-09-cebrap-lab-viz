# Carregar pacote tidyverse
library(tidyverse)

# IMPORTAÇÃO -------------------------------------------------------------------
# Importar os dados que iremos usar
dados_pnud <- read_csv2("dados/base_pnud_min.csv")

dados_pnud_2010 <- dados_pnud |>
  filter(ano == 2010)


# Exemplo da aula passada:
# Como ordenar as barras em um gráfico, de forma que a maior barra fique no topo?


# Código original
media_idhm_por_uf <- dados_pnud_2010 |>
  group_by(regiao_nm, uf_sigla) |>
  summarise(media_idhm = mean(idhm))

media_idhm_por_uf |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col()


# Código alterado:

# Podemos mudar a ordem das barras usando a função fct_reorder() do pacote forcats

media_idhm_por_uf_ordenado <- dados_pnud_2010 |>
  group_by(regiao_nm, uf_sigla) |>
  summarise(media_idhm = mean(idhm)) |>
  ungroup() |>
  mutate(uf_sigla = fct_reorder(uf_sigla, media_idhm))

media_idhm_por_uf_ordenado |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col()



# Personalizando os gráficos --------------------------------------------------

# vamos salvar o gráfico acima

exemplo_grafico <- media_idhm_por_uf_ordenado |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla, fill = regiao_nm) +
  geom_col()

exemplo_grafico


# Labels (textos dos eixos, título, subtítulo, legenda, etc) -----

# Função labs()


exemplo_grafico +
  labs(
    # elementos relacionados à atributos estéticos
    # vai depender dos atributos usados no gráfico
    # dentro da função aes()
    x = "Média do IDHm",
    y = "Sigla da UF", 
    fill = "Região",
    # color = "....",
    # linetype = "....",
    # size = "....",
    
    # elementos que sempre estão disponíveis,
    # tem informações sobre o gráfico
    title = "Média do IDHm por UF em 2010",
    subtitle = "Cores representam a região",
    caption = "Fonte: Dados do PNUD referentes ao Censo.
  Dados extraídos usando o pacote abjData, 
  criado pela Associação Brasileira de Jurimetria."
  )



exemplo_grafico +
  labs(
    x = "IDHM médio",
    y = "UF",
    title = "IDHM médio por UF",
    subtitle = "Ano de 2010",
    caption = "Fonte: PNUD, dados disponíveis no pacote abjData.",
    fill = "Região"
  )


# Temas ------

# Funções que começam com theme_*()
# ex:
exemplo_grafico +
  theme_bw()

exemplo_grafico +
  theme_light()

exemplo_grafico +
  theme_minimal()

exemplo_grafico + 
  theme_void()

# Dica: explore os temas disponíveis no pacote ggthemes

library(ggthemes)

exemplo_grafico +
  theme_clean()

exemplo_grafico +
  theme_fivethirtyeight()

exemplo_grafico +
  theme_economist()

# Personalizando um tema


exemplo_grafico +
  labs(
    x = "IDHM médio",
    y = "UF",
    title = "IDHM médio por UF",
    subtitle = "Ano de 2010",
    caption = "Fonte: PNUD, dados disponíveis no pacote abjData.",
    fill = "Região"
  ) +
  theme(
    axis.title.x = element_text(
      color = "red",
      size = 20,
      face = "bold"
    ),
    axis.title.y = element_text(
      color = "blue",
      size = 20,
      face = "italic"
    ),
    axis.text.x = element_text(
      color = "green",
      size = 15,
      face = "bold"
    ),
    axis.text.y = element_text(
      color = "orange",
      size = 15,
      face = "italic"
    ),
    plot.title = element_text(
      family = "Times New Roman", 
      color = "purple",
      size = 30,
      face = "bold"
    ),
    plot.subtitle = element_text(
      color = "black",
      size = 20,
      face = "italic"
    ),
    plot.caption = element_text(
      color = "gray",
      size = 10,
      face = "bold"
    ),
    legend.title = element_text(
      color = "brown",
      size = 20,
      face = "italic"
    ),
    legend.text = element_text(
      color = "pink",
      size = 15,
      face = "bold"
    ),
    plot.background = element_rect(
      fill = "pink"
    ),
    panel.background = element_rect(
      fill = "lightblue"
    )
  )

# Personalizar o tema em uma função ---
nosso_tema <- function() {
  theme(
    axis.title.x = element_text(
      color = "red",
      size = 20,
      face = "bold"
    ),
    axis.title.y = element_text(
      color = "blue",
      size = 20,
      face = "italic"
    ),
    axis.text.x = element_text(
      color = "green",
      size = 15,
      face = "bold"
    ),
    axis.text.y = element_text(
      color = "orange",
      size = 15,
      face = "italic"
    ),
    plot.title = element_text(
      family = "Times New Roman",
      color = "purple",
      size = 30,
      face = "bold"
    ),
    plot.subtitle = element_text(
      color = "black",
      size = 20,
      face = "italic"
    ),
    plot.caption = element_text(
      color = "gray",
      size = 10,
      face = "bold"
    ),
    legend.title = element_text(
      color = "brown",
      size = 20,
      face = "italic"
    ),
    legend.text = element_text(
      color = "pink",
      size = 15,
      face = "bold"
    ),
    plot.background = element_rect(fill = "pink"),
    panel.background = element_rect(fill = "lightblue")
  )
}


exemplo_grafico +
  labs(
    x = "IDHM médio",
    y = "UF",
    title = "IDHM médio por UF",
    subtitle = "Ano de 2010",
    caption = "Fonte: PNUD, dados disponíveis no pacote abjData.",
    fill = "Região"
  ) +
  nosso_tema()

# Escalas ----------------

# IMPORTANTE

# Funções de escala começam com scale_*

# Funçoes de preenchimento (cores) começam com scale_fill_*

# Funções de borda (cores) começam com scale_color_*

# As escalas de cores podem ser contínuas (numéricas) ou discretas (categorias)

# Escalas de cores --------------------------------

## Escalas de cores discretas

exemplo_grafico +
  scale_fill_viridis_d()

exemplo_grafico +
  scale_fill_brewer(palette = "Set2")

## Escalas de cores contínuas

exemplo_grafico_2 <- media_idhm_por_uf_ordenado |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col(aes(fill = media_idhm))


exemplo_grafico_2 +
  scale_fill_viridis_c()

# degradê
exemplo_grafico_2 +
  scale_fill_continuous(
    low =  "red",
    high = "green", 
  )


# Escalas de cores manuais

exemplo_grafico +
  scale_fill_manual(
    values = c("blue", "#c61414", "#00a000", "#eaea00", "#e99700")
  )

# Outro exemplo de escala manual

media_idhm_por_uf_ordenado |>
  dplyr::mutate(
    cores = dplyr::case_when(
      media_idhm < 0.6 ~ "#b03636",
      media_idhm >= 0.6 & media_idhm < 0.8 ~ "#FFFF00",
      media_idhm >= 0.8 ~ "#048304"
    )
  ) |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col(aes(fill = cores)) +
  scale_fill_identity()

# Existem outros tipos de funções de escala!
# Inicialmente o melhor é focar nas escalas de cores,
# E pesquisar funções específicas quando necessário

# Escala dos eixos
exemplo_grafico +
  scale_x_continuous(limits = c(0, 1),
                     breaks = seq(0, 1, 0.20))

# Escala de datas

url_mananciais <- "https://github.com/beatrizmilz/mananciais/raw/master/inst/extdata/mananciais.csv"

# Lendo o arquivo csv (separado por ponto e vírgula)
mananciais <- read_csv2(url_mananciais)

Sys.setlocale("LC_ALL", "pt_br.utf-8") 

mananciais |> 
  filter(data >= as.Date("2023-01-01")) |> 
  ggplot() +
  aes(x = data, y = volume_porcentagem) +
  geom_line(aes(color = sistema)) +
  facet_wrap(~sistema) +
  scale_x_date(
    date_breaks = "2 months",
    date_labels = "%b"
  )



# Exportar os gráficos ----------------

# Vamos criar um gráfico usando os exemplos vistos, e salvar em um objeto

exemplo_grafico_3 <- media_idhm_por_uf |>
  ggplot() +
  aes(x = media_idhm, y = uf_sigla) +
  geom_col(aes(fill = media_idhm)) +
  # Escala de cores
  scale_fill_viridis_c() +
  # Tema
  theme_light(base_size = 14) +
  # Labels
  labs(
    x = "IDHM médio",
    y = "UF",
    title = "IDHM médio por UF",
    subtitle = "Ano de 2010",
    # caption = "Fonte: PNUD, dados disponíveis no pacote abjData.",
    fill = "IDHM médio"
  ) +
  theme(
    legend.position = "bottom"
  )

# Função ggsave()

ggsave(
  filename = "output/exemplo_grafico_exportar.png",
  plot = exemplo_grafico_3,
  width = 10,
  height = 6,
  units = "in",
  dpi = 600
)


ggsave(
  filename = "output/exemplo_grafico_exportar.svg",
  plot = exemplo_grafico_3,
  width = 10,
  height = 6,
  units = "in",
  dpi = 600
)


# Juntar gráficos ----------------


exemplo_grafico_4 <- dados_pnud_2010 |>
  group_by(regiao_nm, uf_sigla) |>
  summarise(soma_pop = sum(pop)) |>
  mutate(
    soma_pop_milhoes = soma_pop / 1000000
  ) |>
  ggplot() +
  aes(x = soma_pop_milhoes, y = uf_sigla) +
  geom_col(aes(fill = soma_pop_milhoes)) +
  # Escala de cores
  scale_fill_viridis_c() +
  # Tema
  theme_light(base_size = 14) +
  # Labels
  labs(
    x = "População (em milhões)",
    y = "UF",
    title = "População por UF",
    subtitle = "Ano de 2010",
    caption = "Fonte: PNUD, dados disponíveis no pacote abjData.",
    fill = "População (em milhões)"
  ) +
  theme(
    legend.position = "bottom"
  )

# Combinar gráficos em uma única figura ---------
library(patchwork)

# Podemos "somar gráficos"
exemplo_grafico_3 + exemplo_grafico_4 


# Ou podemos usar as funções auxiliares para organizar melhor a figura
grafico_unido <- exemplo_grafico_3 + exemplo_grafico_4  +
  plot_annotation(tag_levels = 'A') +
  plot_layout(nrow = 2)


# salvar em uma imagem
ggsave(
  filename = "output/exemplo_grafico_unido.png",
  plot = grafico_unido,
  width = 10,
  height = 6,
  units = "in",
  dpi = 300
)

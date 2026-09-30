# ============================================================
# OBSERVACIONES DE CAMPO - NUEVO MARCO TARIFARIO DE ASEO
# V9.0: envío por actividad + panel de actividades pendientes después de cada envío
#       observación e implicación ampliadas a 150 caracteres
#       5 puntos independientes por cada actividad incluida en la priorización
#       Sin preguntas del instrumento en ninguna actividad
#       Límites: Observación e implicación 150 caracteres; demás textos libres 100
#       Captura de observaciones por grupos
#       Consolidación con múltiples conclusiones y priorización
# ============================================================

# ------------------------------------------------------------
# 1. CONFIGURACIÓN EDITABLE
# ------------------------------------------------------------

ZONA_HORARIA <- "America/Bogota"
N_PARTICIPANTES_ESPERADOS <- 50L
PUNTOS_POR_ACTIVIDAD <- 5L
N_PRIORIZADOS_DEFAULT <- 10L
CACHE_SEGUNDOS <- 3
MAX_OBSERVACION <- 150L
MAX_IMPLICACION <- 150L
MAX_TEXTO <- 100L

CATEGORIAS <- c(
  funciona = "Funciona",
  parcial = "Funciona parcialmente",
  no_funciona = "No funciona",
  externos = "Factores externos",
  ideas = "Ideas"
)

ACTIVIDADES <- data.frame(
  id = c(7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L),
  actividad = c(
    "Recolección y transporte",
    "Barrido",
    "Comercialización",
    "Corte de césped",
    "Poda",
    "Lavado",
    "Mantenimiento e instalación de cestas",
    "Limpieza de playas",
    "Tratamiento"
  ),
  stringsAsFactors = FALSE
)

# La captura de nuevas observaciones queda cerrada para las actividades ya trabajadas.
# Siguen visibles en Consolidado, Priorización, Resultados y filtros de consulta.
ACTIVIDADES_CAPTURA_ABIERTA <- ACTIVIDADES[!ACTIVIDADES$id %in% c(7L, 8L), , drop = FALSE]

PUNTOS_TOTALES_POR_PERSONA <- PUNTOS_POR_ACTIVIDAD * nrow(ACTIVIDADES)

BLOQUES_OPERATIVOS_NUEVOS <- c(
  "Cuadrilla y personal",
  "Herramientas, equipos, vehículos e insumos",
  "Dotación y EPP",
  "Manejo de residuos resultantes",
  "Activos y personal compartidos"
)

BLOQUES_POR_ACTIVIDAD <- list(
  # Recolección y transporte: se conserva sin cambios.
  `7` = c(
    "Tipo de vehículo, condiciones y estado",
    "Cuadrilla",
    "Frecuencias",
    "Rutas (ordinarias o/y selectivas)",
    "Presentación residuos",
    "Zonas de difícil acceso"
  ),
  # Barrido: se conserva sin cambios.
  `8` = c(
    "Cuadrilla y personal",
    "Herramientas y equipos",
    "Dotación y EPP",
    "Muestra observada (qué evidenciamos al observar la actividad)",
    "Activos y personal compartidos",
    "Transversal"
  ),
  # Comercialización: bloques propios definidos por el equipo.
  `9` = c(
    "Reporte de información al SUI",
    "Facturación conjunta, distribución y liquidación",
    "Atención al usuario (PQRS)",
    "Publicación y campañas",
    "Indexación",
    "Subsidios y contribuciones",
    "Personal",
    "Aplicación de la metodología"
  ),
  # Nuevas actividades operativas: bloques uniformes.
  `10` = BLOQUES_OPERATIVOS_NUEVOS,
  `11` = BLOQUES_OPERATIVOS_NUEVOS,
  `12` = BLOQUES_OPERATIVOS_NUEVOS,
  `13` = BLOQUES_OPERATIVOS_NUEVOS,
  `14` = BLOQUES_OPERATIVOS_NUEVOS,
  # Tratamiento: bloques propios definidos para esta actividad.
  `15` = c(
    "Operación y condiciones de prestación",
    "Tecnología, infraestructura y activos",
    "Flujo y balance de materiales; pesaje y trazabilidad",
    "Costos e ingresos; personal; uso compartido de recursos",
    "Gestión ambiental y operativa; controles de calidad y laboratorio",
    "Producto final y comercialización"
  )
)

COMISIONES <- c(
  "Ruta I-1 · Chipaque – Ubaque – Choachí",
  "D1–D3 · San Pelayo – Canalete – Moñitos",
  "Ruta I-2 : Tena · Anolaima · Anapoima",
  "Ruta III-1 Chocó: Tutunendo · Lloró · Yuto · Samurindó",
  "Ruta I-3 · Guayatá – Macanal – Santa María",
  "Ruta Norte de Santander: Durania · Santiago · San Cayetano",
  "Ruta I-4 · Charalá – Encino – Oiba",
  "Ruta IV-1 · Alejandría – Concepción – El Peñol",
  "Ruta II-1 · Turbaná – San Estanislao – Santa Catalina",
  "Ruta IV-3 · San José – Palestina – Belalcázar",
  "Ruta III-3 · Sandoná – La Florida – Nariño – Chachagüí",
  "Ruta VI-1 · Puerto Nariño",
  "Ruta V-1 · San José del Fragua – Morelia – Belén de los Andaquíes",
  "Ruta I-5 · Guamal – Castilla La Nueva – San Carlos de Guaroa",
  "Ruta II-3 · Urumita – La Jagua del Pilar – Distracción"
)

GRUPOS_MUNICIPIOS <- list(
  "Ruta I-1 · Chipaque – Ubaque – Choachí" = c("Chipaque", "Ubaque", "Choachí"),
  "D1–D3 · San Pelayo – Canalete – Moñitos" = c("San Pelayo", "Canalete", "Moñitos"),
  "Ruta I-2 : Tena · Anolaima · Anapoima" = c("Tena", "Anolaima", "Anapoima"),
  "Ruta III-1 Chocó: Tutunendo · Lloró · Yuto · Samurindó" = c("Tutunendo", "Lloró", "Yuto", "Samurindó"),
  "Ruta I-3 · Guayatá – Macanal – Santa María" = c("Guayatá", "Macanal", "Santa María"),
  "Ruta Norte de Santander: Durania · Santiago · San Cayetano" = c("Durania", "Santiago", "San Cayetano"),
  "Ruta I-4 · Charalá – Encino – Oiba" = c("Charalá", "Encino", "Oiba"),
  "Ruta IV-1 · Alejandría – Concepción – El Peñol" = c("Alejandría", "Concepción", "El Peñol"),
  "Ruta II-1 · Turbaná – San Estanislao – Santa Catalina" = c("Turbaná", "San Estanislao", "Santa Catalina"),
  "Ruta IV-3 · San José – Palestina – Belalcázar" = c("San José", "Palestina", "Belalcázar"),
  "Ruta III-3 · Sandoná – La Florida – Nariño – Chachagüí" = c("Sandoná", "La Florida", "Nariño", "Chachagüí"),
  "Ruta VI-1 · Puerto Nariño" = c("Puerto Nariño"),
  "Ruta V-1 · San José del Fragua – Morelia – Belén de los Andaquíes" = c("San José del Fragua", "Morelia", "Belén de los Andaquíes"),
  "Ruta I-5 · Guamal – Castilla La Nueva – San Carlos de Guaroa" = c("Guamal", "Castilla La Nueva", "San Carlos de Guaroa"),
  "Ruta II-3 · Urumita – La Jagua del Pilar – Distracción" = c("Urumita", "La Jagua del Pilar", "Distracción")
)

MODO_ALMACENAMIENTO <- tolower(Sys.getenv(
  "STORAGE_MODE",
  if (nzchar(Sys.getenv("PGHOST"))) "postgres" else "local"
))

# ------------------------------------------------------------
# 2. RUTAS Y PAQUETES
# ------------------------------------------------------------

detectar_carpeta_app <- function() {
  candidatos <- unique(c(normalizePath(getwd(), winslash = "/", mustWork = FALSE)))
  if (sys.nframe() > 0) {
    for (i in rev(seq_len(sys.nframe()))) {
      of <- tryCatch(sys.frame(i)$ofile, error = function(e) NULL)
      if (!is.null(of) && length(of) == 1 && nzchar(of)) {
        candidatos <- unique(c(candidatos, dirname(normalizePath(of, winslash = "/", mustWork = FALSE))))
      }
    }
  }
  for (d in candidatos) {
    if (file.exists(file.path(d, "app.R"))) return(d)
  }
  normalizePath(getwd(), winslash = "/", mustWork = FALSE)
}

APP_DIR <- detectar_carpeta_app()

PAQUETES <- c(
  "shiny", "dplyr", "tidyr", "stringr", "readr",
  "openxlsx", "uuid", "filelock", "stringi", "tibble"
)
faltantes <- PAQUETES[!vapply(PAQUETES, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltantes) > 0) {
  stop("Faltan paquetes: ", paste(faltantes, collapse = ", "),
       ". Ejecute install.packages(c(\"", paste(faltantes, collapse = "\", \""), "\"))")
}

library(shiny)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(openxlsx)
library(uuid)
library(filelock)
library(stringi)
library(tibble)

if (MODO_ALMACENAMIENTO == "postgres") {
  paquetes_db <- c("DBI", "RPostgres", "pool")
  faltantes_db <- paquetes_db[!vapply(paquetes_db, requireNamespace, logical(1), quietly = TRUE)]
  if (length(faltantes_db) > 0) stop("Faltan paquetes PostgreSQL: ", paste(faltantes_db, collapse = ", "))
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || is.na(x[1])) y else x
}

# ------------------------------------------------------------
# 3. HELPERS
# ------------------------------------------------------------

now_bogota <- function() {
  format(Sys.time(), tz = ZONA_HORARIA, format = "%Y-%m-%d %H:%M:%OS6%z")
}

normalizar_nombre <- function(x) {
  x <- trimws(x %||% "")
  x <- stringi::stri_trans_general(x, "Latin-ASCII")
  x <- tolower(x)
  gsub("\\s+", " ", x)
}

normalizar_clave <- function(x) {
  x <- stringi::stri_trans_general(x %||% "", "Latin-ASCII")
  x <- tolower(x)
  x <- gsub("[^a-z0-9]+", "_", x)
  gsub("^_+|_+$", "", x)
}

activity_name <- function(id) {
  out <- ACTIVIDADES$actividad[match(as.integer(id), ACTIVIDADES$id)]
  ifelse(length(out) == 0 || is.na(out), "", out)
}

# Cada persona puede tener un envío vigente independiente por actividad.
# Se conserva dentro de varchar(100) aunque el nombre sea largo.
vote_participant_key <- function(participant, actividad_id) {
  base <- substr(normalizar_nombre(participant), 1, 80)
  paste0(base, "::act:", as.integer(actividad_id))
}

base_vote_participant_key <- function(x) {
  sub("::act:[0-9]+$", "", as.character(x))
}

format_fecha <- function(x) {
  if (length(x) == 0 || is.na(x) || !nzchar(as.character(x))) return("")
  z <- suppressWarnings(as.POSIXct(x, tz = ZONA_HORARIA))
  if (is.na(z)) return(as.character(x))
  format(z, tz = ZONA_HORARIA, "%d/%m/%Y %H:%M")
}

parse_categories <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x) || !nzchar(x)) return(character(0))
  out <- trimws(unlist(strsplit(x, "\\|")))
  out[nzchar(out)]
}

make_group_key <- function(actividad_id, bloque) {
  paste0(as.integer(actividad_id), "__", normalizar_clave(bloque))
}

# ------------------------------------------------------------
# 5. ANÁLISIS TEXTUAL SIMPLE
# ------------------------------------------------------------

STOPWORDS_ES <- unique(c(
  "para", "como", "pero", "porque", "esta", "este", "estas", "estos", "desde", "hasta",
  "entre", "sobre", "donde", "cuando", "tambien", "tiene", "tienen", "hacer", "hace", "hacen",
  "muy", "mas", "menos", "una", "unas", "uno", "unos", "del", "las", "los", "que", "con",
  "sin", "por", "sus", "son", "fue", "ser", "se", "la", "el", "en", "de", "y", "o", "a",
  "al", "un", "es", "no", "si", "ya", "lo", "le", "les", "ha", "han", "hay", "esto",
  "eso", "esa", "ese", "observacion", "observaciones", "municipio", "municipios", "actividad",
  "servicio", "campo", "prestador", "prestadores", "prestacion", "vimos", "visto", "vemos",
  "observa", "observo", "observamos", "observado", "evidencia", "evidencio", "evidenciamos"
))

palabras_frecuentes <- function(textos, n = 8L) {
  if (length(textos) == 0) return(tibble(palabra = character(), frecuencia = integer()))
  txt <- paste(textos[!is.na(textos)], collapse = " ")
  txt <- stringi::stri_trans_general(txt, "Latin-ASCII")
  txt <- tolower(txt)
  txt <- gsub("[^a-z0-9]+", " ", txt)
  words <- unlist(strsplit(txt, "\\s+"))
  words <- words[nchar(words) >= 4]
  words <- words[!words %in% STOPWORDS_ES]
  if (length(words) == 0) return(tibble(palabra = character(), frecuencia = integer()))
  tb <- sort(table(words), decreasing = TRUE)
  tibble(palabra = names(tb), frecuencia = as.integer(tb)) %>%
    filter(frecuencia >= 2) %>%
    slice_head(n = n)
}

formatear_palabras <- function(freq) {
  if (nrow(freq) == 0) return("Aún no hay términos repetidos suficientes")
  paste0(freq$palabra, " (", freq$frecuencia, ")", collapse = " · ")
}

sintesis_preliminar <- function(obs_df) {
  if (nrow(obs_df) == 0) return("Sin observaciones para sintetizar.")
  freq <- palabras_frecuentes(obs_df$observacion, 5)
  terms <- if (nrow(freq) > 0) paste(freq$palabra, collapse = ", ") else "aún no hay términos repetidos suficientes"
  paste0(
    "Se agrupan ", nrow(obs_df), " observación(es) aportadas por ",
    dplyr::n_distinct(obs_df$grupo_key), " grupo(s). Los términos más recurrentes son: ",
    terms, ". Esta síntesis es descriptiva y debe ser validada por el equipo que consolida."
  )
}

# ------------------------------------------------------------
# 6. ESTRUCTURAS DE DATOS
# ------------------------------------------------------------

OBS_COLS <- c(
  "id", "actividad_id", "actividad", "grupo", "grupo_key", "persona", "persona_key",
  "bloque", "pregunta_codigo", "pregunta_texto", "observacion", "categorias",
  "municipios", "implicacion", "created_at"
)

CONC_COLS <- c(
  "id", "group_key", "actividad_id", "actividad", "bloque", "conclusion",
  "habilitada_votacion", "actualizado_por", "updated_at"
)

VOTOS_COLS <- c(
  "id", "envio_id", "participante", "participante_key", "conclusion_id", "puntos", "submitted_at"
)

empty_observaciones <- function() {
  tibble(
    id = character(), actividad_id = integer(), actividad = character(), grupo = character(),
    grupo_key = character(), persona = character(), persona_key = character(), bloque = character(),
    pregunta_codigo = character(), pregunta_texto = character(), observacion = character(),
    categorias = character(), municipios = character(), implicacion = character(), created_at = character()
  )
}

empty_conclusiones <- function() {
  tibble(
    id = character(), group_key = character(), actividad_id = integer(), actividad = character(),
    bloque = character(), conclusion = character(), habilitada_votacion = logical(),
    actualizado_por = character(), updated_at = character()
  )
}

empty_votos <- function() {
  tibble(
    id = character(), envio_id = character(), participante = character(), participante_key = character(),
    conclusion_id = character(), puntos = integer(), submitted_at = character()
  )
}

# ------------------------------------------------------------
# 7. ALMACENAMIENTO LOCAL
# ------------------------------------------------------------

LOCAL_DIR <- file.path(APP_DIR, "data")
LOCAL_OBS <- file.path(LOCAL_DIR, "observaciones_v6.csv")
LOCAL_CONC <- file.path(LOCAL_DIR, "conclusiones_v6.csv")
LOCAL_VOTOS <- file.path(LOCAL_DIR, "votos_v6.csv")
DB_POOL <- NULL

ensure_local_files <- function() {
  if (!dir.exists(LOCAL_DIR)) dir.create(LOCAL_DIR, recursive = TRUE)
  if (!file.exists(LOCAL_OBS)) write_csv(empty_observaciones(), LOCAL_OBS)
  if (!file.exists(LOCAL_CONC)) write_csv(empty_conclusiones(), LOCAL_CONC)
  if (!file.exists(LOCAL_VOTOS)) write_csv(empty_votos(), LOCAL_VOTOS)
}

read_csv_typed <- function(path, empty_fun, expected, converter = NULL) {
  if (!file.exists(path)) return(empty_fun())
  x <- suppressMessages(read_csv(path, show_col_types = FALSE, col_types = cols(.default = col_character())))
  if (nrow(x) == 0) return(empty_fun())
  missing <- setdiff(expected, names(x))
  if (length(missing) > 0) stop("El archivo local pertenece a otra versión. Faltan: ", paste(missing, collapse = ", "))
  if (!is.null(converter)) x <- converter(x)
  x %>% select(all_of(expected))
}

read_local_observaciones <- function() {
  ensure_local_files()
  read_csv_typed(LOCAL_OBS, empty_observaciones, OBS_COLS, function(x) x %>% mutate(actividad_id = as.integer(actividad_id)))
}

read_local_conclusiones <- function() {
  ensure_local_files()
  read_csv_typed(LOCAL_CONC, empty_conclusiones, CONC_COLS, function(x) x %>% mutate(
    actividad_id = as.integer(actividad_id),
    habilitada_votacion = tolower(habilitada_votacion) %in% c("true", "t", "1", "si", "sí")
  ))
}

read_local_votos <- function() {
  ensure_local_files()
  read_csv_typed(LOCAL_VOTOS, empty_votos, VOTOS_COLS, function(x) x %>% mutate(puntos = as.integer(puntos)))
}

with_file_lock <- function(path, code) {
  lk <- filelock::lock(paste0(path, ".lock"), timeout = 10000)
  if (is.null(lk)) stop("No fue posible obtener el bloqueo del archivo local.")
  on.exit(filelock::unlock(lk), add = TRUE)
  force(code)
}

insert_local_observacion <- function(row) {
  with_file_lock(LOCAL_OBS, write_csv(bind_rows(read_local_observaciones(), row), LOCAL_OBS))
}

save_local_conclusion <- function(row, mode = c("add", "edit")) {
  mode <- match.arg(mode)
  with_file_lock(LOCAL_CONC, {
    current <- read_local_conclusiones()
    if (mode == "add") {
      write_csv(bind_rows(current, row), LOCAL_CONC)
    } else {
      idx <- which(current$id == row$id)
      if (length(idx) == 0) stop("No se encontró la conclusión para editar.")
      current[idx[1], ] <- row[1, ]
      write_csv(current, LOCAL_CONC)
    }
  })
}

insert_local_votos <- function(rows) {
  with_file_lock(LOCAL_VOTOS, write_csv(bind_rows(read_local_votos(), rows), LOCAL_VOTOS))
}

# ------------------------------------------------------------
# 8. POSTGRESQL / SUPABASE
# ------------------------------------------------------------

init_postgres <- function() {
  required <- c("PGHOST", "PGPORT", "PGDATABASE", "PGUSER", "PGPASSWORD")
  missing <- required[!nzchar(Sys.getenv(required))]
  if (length(missing) > 0) stop("Faltan variables PostgreSQL: ", paste(missing, collapse = ", "))

  DB_POOL <<- pool::dbPool(
    drv = RPostgres::Postgres(),
    host = Sys.getenv("PGHOST"),
    port = as.integer(Sys.getenv("PGPORT", "5432")),
    dbname = Sys.getenv("PGDATABASE", "postgres"),
    user = Sys.getenv("PGUSER"),
    password = Sys.getenv("PGPASSWORD"),
    sslmode = Sys.getenv("PGSSLMODE", "require"),
    minSize = 1,
    maxSize = 10
  )

  con <- pool::poolCheckout(DB_POOL)
  on.exit(pool::poolReturn(con), add = TRUE)
  DBI::dbGetQuery(con, "SELECT 1 AS ok")
  requeridas <- c("configuracion_taller", "grupos", "observaciones", "conclusiones", "envios_votacion", "detalle_votacion")
  faltan <- setdiff(requeridas, DBI::dbListTables(con))
  if (length(faltan) > 0) stop("Faltan tablas del esquema V6: ", paste(faltan, collapse = ", "))
}

read_postgres_observaciones <- function() {
  x <- DBI::dbGetQuery(DB_POOL, "
    SELECT id, actividad_id, actividad, grupo, persona_registra, bloque,
           codigo_pregunta, pregunta, observacion,
           funciona, funciona_parcialmente, no_funciona, factores_externos, ideas,
           municipios, implicacion, creado_en
    FROM public.observaciones
    WHERE activa = true
      AND actividad_id IN (7, 8, 9, 10, 11, 12, 13, 14, 15)
    ORDER BY creado_en, id
  ")
  if (nrow(x) == 0) return(empty_observaciones())

  cats <- apply(
    x[, c("funciona", "funciona_parcialmente", "no_funciona", "factores_externos", "ideas"), drop = FALSE],
    1,
    function(z) {
      labels <- unname(CATEGORIAS)
      paste(labels[as.logical(z)], collapse = " | ")
    }
  )

  tibble(
    id = as.character(x$id),
    actividad_id = as.integer(x$actividad_id),
    actividad = x$actividad,
    grupo = x$grupo,
    grupo_key = vapply(x$grupo, normalizar_nombre, character(1)),
    persona = x$persona_registra,
    persona_key = vapply(x$persona_registra, normalizar_nombre, character(1)),
    bloque = ifelse(is.na(x$bloque), "", x$bloque),
    pregunta_codigo = ifelse(is.na(x$codigo_pregunta), "", x$codigo_pregunta),
    pregunta_texto = ifelse(is.na(x$pregunta), "", x$pregunta),
    observacion = x$observacion,
    categorias = cats,
    municipios = ifelse(is.na(x$municipios), "", x$municipios),
    implicacion = ifelse(is.na(x$implicacion), "", x$implicacion),
    created_at = format(as.POSIXct(x$creado_en), tz = ZONA_HORARIA, format = "%Y-%m-%d %H:%M:%OS6%z")
  )
}

read_postgres_conclusiones <- function() {
  x <- DBI::dbGetQuery(DB_POOL, "
    SELECT id, actividad_id, actividad, bloque, conclusion,
           habilitada_priorizacion, actualizado_por, actualizado_en
    FROM public.conclusiones
    WHERE activa = true
      AND actividad_id IN (7, 8, 9, 10, 11, 12, 13, 14, 15)
    ORDER BY actividad_id, bloque, id
  ")
  if (nrow(x) == 0) return(empty_conclusiones())

  tibble(
    id = as.character(x$id),
    group_key = mapply(make_group_key, x$actividad_id, x$bloque, USE.NAMES = FALSE),
    actividad_id = as.integer(x$actividad_id),
    actividad = x$actividad,
    bloque = x$bloque,
    conclusion = x$conclusion,
    habilitada_votacion = as.logical(x$habilitada_priorizacion),
    actualizado_por = ifelse(is.na(x$actualizado_por), "", x$actualizado_por),
    updated_at = format(as.POSIXct(x$actualizado_en), tz = ZONA_HORARIA, format = "%Y-%m-%d %H:%M:%OS6%z")
  )
}

read_postgres_votos <- function() {
  x <- DBI::dbGetQuery(DB_POOL, "
    SELECT dv.envio_id, ev.participante, ev.participante_clave,
           dv.conclusion_id, dv.puntos, ev.creado_en
    FROM public.detalle_votacion dv
    JOIN public.envios_votacion ev ON ev.id = dv.envio_id
    ORDER BY ev.creado_en, dv.envio_id, dv.conclusion_id
  ")
  if (nrow(x) == 0) return(empty_votos())

  tibble(
    id = paste0(x$envio_id, "_", x$conclusion_id),
    envio_id = as.character(x$envio_id),
    participante = x$participante,
    participante_key = x$participante_clave,
    conclusion_id = as.character(x$conclusion_id),
    puntos = as.integer(x$puntos),
    submitted_at = format(as.POSIXct(x$creado_en), tz = ZONA_HORARIA, format = "%Y-%m-%d %H:%M:%OS6%z")
  )
}

insert_postgres_observacion <- function(row) {
  cats <- parse_categories(row$categorias)
  DBI::dbExecute(
    DB_POOL,
    "INSERT INTO public.observaciones
      (grupo, persona_registra, actividad_id, actividad, bloque,
       codigo_pregunta, pregunta, observacion,
       funciona, funciona_parcialmente, no_funciona, factores_externos, ideas,
       municipios, implicacion)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)",
    params = list(
      row$grupo,
      row$persona,
      as.integer(row$actividad_id),
      row$actividad,
      row$bloque,
      ifelse(nzchar(row$pregunta_codigo), row$pregunta_codigo, NA_character_),
      ifelse(nzchar(row$pregunta_texto), row$pregunta_texto, NA_character_),
      row$observacion,
      "Funciona" %in% cats,
      "Funciona parcialmente" %in% cats,
      "No funciona" %in% cats,
      "Factores externos" %in% cats,
      "Ideas" %in% cats,
      row$municipios,
      row$implicacion
    )
  )
}

save_postgres_conclusion <- function(row, mode = c("add", "edit")) {
  mode <- match.arg(mode)
  if (mode == "add") {
    DBI::dbExecute(
      DB_POOL,
      "INSERT INTO public.conclusiones
        (actividad_id, actividad, bloque, conclusion, actualizado_por,
         habilitada_priorizacion, estado, activa)
       VALUES ($1,$2,$3,$4,$5,$6,'aprobada',true)",
      params = list(
        as.integer(row$actividad_id), row$actividad, row$bloque, row$conclusion,
        row$actualizado_por, as.logical(row$habilitada_votacion)
      )
    )
  } else {
    DBI::dbExecute(
      DB_POOL,
      "UPDATE public.conclusiones
       SET conclusion = $1,
           actualizado_por = $2,
           habilitada_priorizacion = $3,
           estado = 'aprobada',
           activa = true
       WHERE id = $4",
      params = list(
        row$conclusion, row$actualizado_por, as.logical(row$habilitada_votacion), as.integer(row$id)
      )
    )
  }
}

insert_postgres_votos <- function(rows) {
  con <- pool::poolCheckout(DB_POOL)
  on.exit(pool::poolReturn(con), add = TRUE)

  DBI::dbWithTransaction(con, {
    participante <- rows$participante[1]
    pkey <- rows$participante_key[1]

    # Evita esperas indefinidas: cada escritura tiene tiempos máximos y el
    # bloqueo por participante/actividad es no bloqueante.
    DBI::dbExecute(con, "SET LOCAL lock_timeout = '3s'")
    DBI::dbExecute(con, "SET LOCAL statement_timeout = '12s'")
    lock_ok <- DBI::dbGetQuery(
      con,
      "SELECT pg_try_advisory_xact_lock(hashtext($1)) AS locked",
      params = list(pkey)
    )$locked[1]
    if (!isTRUE(lock_ok)) {
      stop("Ya hay un envío de esta actividad en proceso. Espere unos segundos y vuelva a intentar.")
    }

    detalles <- rows %>%
      transmute(
        conclusion_id = as.integer(conclusion_id),
        puntos = as.integer(puntos)
      ) %>%
      filter(!is.na(conclusion_id), !is.na(puntos), puntos > 0) %>%
      group_by(conclusion_id) %>%
      summarise(puntos = sum(puntos), .groups = "drop")

    if (nrow(detalles) == 0) stop("La priorización no contiene puntos.")

    ids <- unique(detalles$conclusion_id)
    id_sql <- paste(ids, collapse = ",")
    validas <- DBI::dbGetQuery(
      con,
      paste0(
        "SELECT id, actividad_id FROM public.conclusiones ",
        "WHERE activa = true AND habilitada_priorizacion = true AND id IN (", id_sql, ")"
      )
    )

    if (nrow(validas) != length(ids)) {
      stop("Una de las conclusiones ya no está habilitada para priorización.")
    }

    detalles <- detalles %>%
      left_join(validas, by = c("conclusion_id" = "id"))

    actividades_envio <- unique(detalles$actividad_id)
    if (length(actividades_envio) != 1) {
      stop("Cada envío debe corresponder a una sola actividad.")
    }

    total <- sum(detalles$puntos)
    if (total != as.integer(PUNTOS_POR_ACTIVIDAD)) {
      stop(
        "Debe asignar exactamente ", PUNTOS_POR_ACTIVIDAD,
        " puntos en ", activity_name(actividades_envio[1]), "."
      )
    }

    # Reemplaza solo el envío vigente de esa persona para esa actividad.
    DBI::dbExecute(
      con,
      "UPDATE public.envios_votacion SET vigente = false WHERE participante_clave = $1 AND vigente = true",
      params = list(pkey)
    )

    envio <- DBI::dbGetQuery(
      con,
      "INSERT INTO public.envios_votacion
        (participante, participante_clave, total_puntos, vigente)
       VALUES ($1,$2,$3,true)
       RETURNING id",
      params = list(participante, pkey, total)
    )$id[1]

    values_sql <- paste0(
      "(", as.integer(envio), ",", detalles$conclusion_id, ",", detalles$puntos, ")",
      collapse = ","
    )
    DBI::dbExecute(
      con,
      paste0(
        "INSERT INTO public.detalle_votacion (envio_id, conclusion_id, puntos) VALUES ",
        values_sql
      )
    )
  })
}

has_existing_vote <- function(participante_key) {
  if (MODO_ALMACENAMIENTO == "local") {
    x <- read_local_votos()
    pkey <- participante_key
    return(any(x$participante_key == pkey))
  }

  x <- DBI::dbGetQuery(
    DB_POOL,
    "SELECT EXISTS(SELECT 1 FROM public.envios_votacion WHERE participante_clave = $1 AND vigente = true) AS existe",
    params = list(participante_key)
  )
  isTRUE(x$existe[1])
}

# ------------------------------------------------------------
# 9. ABSTRACCIÓN DE ALMACENAMIENTO
# ------------------------------------------------------------

init_storage <- function() {
  if (MODO_ALMACENAMIENTO == "local") ensure_local_files()
  else if (MODO_ALMACENAMIENTO == "postgres") init_postgres()
  else stop("STORAGE_MODE debe ser 'local' o 'postgres'.")
}

read_all_storage <- function() {
  if (MODO_ALMACENAMIENTO == "local") {
    list(
      observaciones = read_local_observaciones(),
      conclusiones = read_local_conclusiones(),
      votos = read_local_votos()
    )
  } else {
    list(
      observaciones = read_postgres_observaciones(),
      conclusiones = read_postgres_conclusiones(),
      votos = read_postgres_votos()
    )
  }
}

insert_observacion <- function(row) {
  if (MODO_ALMACENAMIENTO == "local") insert_local_observacion(row) else insert_postgres_observacion(row)
}

save_conclusion <- function(row, mode) {
  if (MODO_ALMACENAMIENTO == "local") save_local_conclusion(row, mode) else save_postgres_conclusion(row, mode)
  if (exists("PRIORITY_CACHE", inherits = TRUE)) {
    PRIORITY_CACHE$last_refresh <- as.POSIXct("1970-01-01", tz = "UTC")
  }
}

insert_votos <- function(rows) {
  if (MODO_ALMACENAMIENTO == "local") insert_local_votos(rows) else insert_postgres_votos(rows)
}

# ------------------------------------------------------------
# 10. CACHÉ COMPARTIDA
# ------------------------------------------------------------

CACHE <- new.env(parent = emptyenv())
CACHE$observaciones <- empty_observaciones()
CACHE$conclusiones <- empty_conclusiones()
CACHE$votos <- empty_votos()

# Caché liviana para la pestaña de Priorización. Es compartida por todas las
# sesiones que caen en el mismo worker de R, reduciendo lecturas simultáneas.
PRIORITY_CACHE <- new.env(parent = emptyenv())
PRIORITY_CACHE$conclusiones <- empty_conclusiones()
PRIORITY_CACHE$last_refresh <- as.POSIXct("1970-01-01", tz = "UTC")
PRIORITY_CACHE_TTL <- 60
CACHE$last_read <- as.POSIXct(NA)

refresh_cache <- function(force = FALSE) {
  expired <- is.na(CACHE$last_read) ||
    as.numeric(difftime(Sys.time(), CACHE$last_read, units = "secs")) >= CACHE_SEGUNDOS
  if (force || expired) {
    x <- read_all_storage()
    CACHE$observaciones <- x$observaciones
    CACHE$conclusiones <- x$conclusiones
    CACHE$votos <- x$votos
    CACHE$last_read <- Sys.time()
  }
  invisible(TRUE)
}

init_storage()
refresh_cache(force = TRUE)

# ------------------------------------------------------------
# 11. CONSOLIDACIÓN Y RANKING
# ------------------------------------------------------------

build_group_summary <- function(observaciones) {
  if (nrow(observaciones) == 0) {
    return(tibble(
      group_key = character(), actividad_id = integer(), actividad = character(), bloque = character(),
      categorias = character(), n_observaciones = integer(), n_grupos = integer(), municipios = character(),
      palabras_frecuentes = character(), sintesis_preliminar = character()
    ))
  }

  keys <- observaciones %>%
    mutate(group_key = mapply(make_group_key, actividad_id, bloque, USE.NAMES = FALSE)) %>%
    distinct(group_key, actividad_id, actividad, bloque)

  bind_rows(lapply(seq_len(nrow(keys)), function(i) {
    k <- keys$group_key[i]
    g <- observaciones %>%
      mutate(group_key = mapply(make_group_key, actividad_id, bloque, USE.NAMES = FALSE)) %>%
      filter(group_key == k)

    municipios <- unique(trimws(unlist(strsplit(paste(g$municipios, collapse = " | "), "\\|"))))
    municipios <- municipios[nzchar(municipios)]
    cats <- unique(unlist(lapply(g$categorias, parse_categories)))
    cats <- unname(CATEGORIAS)[unname(CATEGORIAS) %in% cats]

    tibble(
      group_key = k,
      actividad_id = keys$actividad_id[i],
      actividad = keys$actividad[i],
      bloque = keys$bloque[i],
      categorias = paste(cats, collapse = " | "),
      n_observaciones = nrow(g),
      n_grupos = n_distinct(g$grupo_key),
      municipios = paste(sort(unique(municipios)), collapse = " · "),
      palabras_frecuentes = formatear_palabras(palabras_frecuentes(g$observacion, 8)),
      sintesis_preliminar = sintesis_preliminar(g)
    )
  })) %>% arrange(actividad_id, bloque)
}

latest_vote_rows <- function(votos) {
  if (nrow(votos) == 0) return(empty_votos())
  latest <- votos %>%
    group_by(participante_key, envio_id) %>%
    summarise(submitted_at = max(submitted_at), .groups = "drop") %>%
    arrange(participante_key, desc(submitted_at), desc(envio_id)) %>%
    group_by(participante_key) %>% slice(1) %>% ungroup() %>%
    select(participante_key, envio_id)
  votos %>% inner_join(latest, by = c("participante_key", "envio_id"))
}

build_ranking <- function(conclusiones, votos, top_n) {
  if (nrow(conclusiones) == 0) return(conclusiones %>% mutate(
    puntos = integer(), posicion_general = integer(), posicion_actividad = integer(), priorizado = logical()
  ))

  latest <- latest_vote_rows(votos)
  pts <- latest %>% group_by(conclusion_id) %>% summarise(puntos = sum(puntos), .groups = "drop")

  conclusiones %>%
    filter(nzchar(conclusion)) %>%
    left_join(pts, by = c("id" = "conclusion_id")) %>%
    mutate(puntos = coalesce(as.integer(puntos), 0L)) %>%
    arrange(desc(puntos), actividad_id, bloque, id) %>%
    mutate(posicion_general = row_number()) %>%
    group_by(actividad_id) %>% mutate(posicion_actividad = row_number()) %>% ungroup() %>%
    mutate(priorizado = puntos > 0 & posicion_general <= as.integer(top_n))
}

# ------------------------------------------------------------
# 12. UI HELPERS
# ------------------------------------------------------------

category_badge <- function(cat) {
  key <- names(CATEGORIAS)[match(cat, unname(CATEGORIAS))]
  key <- ifelse(is.na(key), "neutral", key)
  tags$span(class = paste("category-badge", paste0("cat-", key)), cat)
}

category_badges <- function(text) {
  cats <- parse_categories(text)
  if (length(cats) == 0) return(tags$span(class = "category-badge cat-neutral", "Sin clasificación"))
  tagList(lapply(cats, category_badge))
}

metric_card <- function(label, value, subtitle = NULL) {
  div(
    class = "metric-card",
    div(class = "metric-value", value),
    div(class = "metric-label", label),
    if (!is.null(subtitle)) div(class = "metric-subtitle", subtitle)
  )
}

# ------------------------------------------------------------
# 13. EXCEL
# ------------------------------------------------------------

crear_excel_resultados <- function(file, observaciones, groups, conclusiones, votos, ranking) {
  latest <- latest_vote_rows(votos)
  wb <- createWorkbook()

  brand <- "#0B6477"
  dark <- "#18323B"
  title_style <- createStyle(textDecoration = "bold", fontColour = "#FFFFFF", fgFill = brand)
  header_style <- createStyle(textDecoration = "bold", fontColour = "#FFFFFF", fgFill = dark, wrapText = TRUE, halign = "center")
  body_style <- createStyle(wrapText = TRUE, valign = "top", border = "TopBottomLeftRight", borderColour = "#E1E7E9")

  addWorksheet(wb, "Observaciones")
  m1 <- observaciones %>% transmute(
    ID = id,
    Actividad = actividad,
    `Comisión / grupo` = grupo,
    `Registrado por` = persona,
    `Bloque temático` = bloque,
    `Observación de campo` = observacion,
    Clasificación = categorias,
    Municipios = municipios,
    `Implicación para el estudio` = implicacion,
    `Fecha de registro` = created_at
  )
  writeData(wb, "Observaciones", m1, withFilter = TRUE)
  if (ncol(m1) > 0) addStyle(wb, "Observaciones", header_style, rows = 1, cols = 1:ncol(m1), gridExpand = TRUE)
  setColWidths(wb, "Observaciones", cols = 1:ncol(m1), widths = c(10,28,38,24,34,65,30,28,55,22))

  addWorksheet(wb, "Consolidado")
  m2 <- groups %>% transmute(
    Actividad = actividad,
    `Bloque temático` = bloque,
    `N observaciones` = n_observaciones,
    `N grupos` = n_grupos,
    `Clasificaciones presentes` = categorias,
    Municipios = municipios,
    `Palabras frecuentes` = palabras_frecuentes,
    `Síntesis preliminar` = sintesis_preliminar
  )
  writeData(wb, "Consolidado", m2, withFilter = TRUE)
  if (ncol(m2) > 0) addStyle(wb, "Consolidado", header_style, rows = 1, cols = 1:ncol(m2), gridExpand = TRUE)
  setColWidths(wb, "Consolidado", cols = 1:ncol(m2), widths = c(28,35,15,12,38,35,45,70))

  addWorksheet(wb, "Conclusiones")
  mc <- conclusiones %>% transmute(
    ID = id,
    Actividad = actividad,
    `Bloque temático` = bloque,
    Conclusión = conclusion,
    `Habilitada para priorización` = ifelse(habilitada_votacion, "Sí", "No"),
    `Última actualización` = updated_at
  )
  writeData(wb, "Conclusiones", mc, withFilter = TRUE)
  if (ncol(mc) > 0) addStyle(wb, "Conclusiones", header_style, rows = 1, cols = 1:ncol(mc), gridExpand = TRUE)
  setColWidths(wb, "Conclusiones", cols = 1:ncol(mc), widths = c(10,28,35,75,22,24))

  addWorksheet(wb, "Priorización")
  pr <- ranking %>% transmute(
    `Pos. general` = posicion_general,
    `Pos. actividad` = posicion_actividad,
    Actividad = actividad,
    `Bloque temático` = bloque,
    Conclusión = conclusion,
    Puntos = puntos,
    Priorizada = ifelse(priorizado, "Sí", "No")
  )
  writeData(wb, "Priorización", pr, withFilter = TRUE)
  if (ncol(pr) > 0) addStyle(wb, "Priorización", header_style, rows = 1, cols = 1:ncol(pr), gridExpand = TRUE)
  setColWidths(wb, "Priorización", cols = 1:ncol(pr), widths = c(13,14,28,35,75,10,12))

  addWorksheet(wb, "Resumen por actividad")
  res <- groups %>% group_by(actividad_id, actividad) %>% summarise(
    `Observaciones` = sum(n_observaciones),
    `Bloques con aportes` = n(),
    .groups = "drop"
  ) %>%
    left_join(
      conclusiones %>% group_by(actividad_id) %>% summarise(
        `Conclusiones` = n(),
        `Habilitadas para votar` = sum(habilitada_votacion),
        .groups = "drop"
      ),
      by = "actividad_id"
    ) %>%
    left_join(
      ranking %>% group_by(actividad_id) %>% summarise(
        Puntos = sum(puntos),
        Priorizadas = sum(priorizado),
        .groups = "drop"
      ),
      by = "actividad_id"
    ) %>%
    mutate(across(c(`Conclusiones`, `Habilitadas para votar`, Puntos, Priorizadas), ~coalesce(.x, 0L))) %>%
    select(-actividad_id)
  writeData(wb, "Resumen por actividad", res, withFilter = TRUE)
  if (ncol(res) > 0) addStyle(wb, "Resumen por actividad", header_style, rows = 1, cols = 1:ncol(res), gridExpand = TRUE)
  setColWidths(wb, "Resumen por actividad", cols = 1:ncol(res), widths = c(30,15,18,15,22,12,12))

  addWorksheet(wb, "Votos crudos")
  vc <- votos %>% transmute(
    `ID envío` = envio_id,
    Participante = participante,
    `ID conclusión` = conclusion_id,
    Puntos = puntos,
    Fecha = submitted_at
  )
  writeData(wb, "Votos crudos", vc, withFilter = TRUE)
  if (ncol(vc) > 0) addStyle(wb, "Votos crudos", header_style, rows = 1, cols = 1:ncol(vc), gridExpand = TRUE)
  setColWidths(wb, "Votos crudos", cols = 1:ncol(vc), widths = c(18,28,15,10,22))

  for (aid in ACTIVIDADES$id) {
    sname <- substr(activity_name(aid), 1, 31)
    addWorksheet(wb, sname)
    oo <- m1 %>% filter(Actividad == activity_name(aid))
    cc <- mc %>% filter(Actividad == activity_name(aid))
    writeData(wb, sname, paste0("OBSERVACIONES - ", toupper(activity_name(aid))), startRow = 1)
    addStyle(wb, sname, title_style, rows = 1, cols = 1:max(1, ncol(oo)), gridExpand = TRUE)
    writeData(wb, sname, oo, startRow = 3, withFilter = TRUE)
    if (ncol(oo) > 0) addStyle(wb, sname, header_style, rows = 3, cols = 1:ncol(oo), gridExpand = TRUE)
    start2 <- max(6, nrow(oo) + 6)
    writeData(wb, sname, "CONCLUSIONES", startRow = start2)
    addStyle(wb, sname, title_style, rows = start2, cols = 1:max(1, ncol(cc)), gridExpand = TRUE)
    writeData(wb, sname, cc, startRow = start2 + 2, withFilter = TRUE)
    if (ncol(cc) > 0) addStyle(wb, sname, header_style, rows = start2 + 2, cols = 1:ncol(cc), gridExpand = TRUE)
  }

  saveWorkbook(wb, file, overwrite = TRUE)
}

# ------------------------------------------------------------
# 14. INTERFAZ
# ------------------------------------------------------------

ui <- navbarPage(
  title = "Observaciones de campo",
  id = "main_tabs",
  header = tagList(
    tags$head(
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      includeCSS(file.path(APP_DIR, "www", "styles.css")),
      includeScript(file.path(APP_DIR, "www", "app.js"))
    )
  ),

  tabPanel(
    "Captura de observaciones",
    value = "captura",
    div(
      class = "page-wrap",
      div(
        class = "page-intro",
        div(class = "eyebrow", "CAPTURA POR GRUPOS"),
        tags$h2("Registrar una observación"),
        tags$p("Cada grupo registra observaciones para la actividad del servicio que corresponda."),
        div(
          class = "capture-closed-notice",
          tags$strong("Captura cerrada para Recolección y transporte y Barrido. "),
          "Estas actividades permanecen disponibles para consulta, consolidación, priorización y resultados, pero ya no aceptan nuevas observaciones."
        )
      ),
      fluidRow(
        column(
          width = 5,
          div(
            class = "panel-card form-card",
            selectizeInput(
              "comision_registro", "Comisión / grupo que aporta",
              choices = COMISIONES, selected = COMISIONES[1],
              options = list(create = FALSE, placeholder = "Seleccione el grupo")
            ),
            textInput("persona_registro", "Nombre de quien registra", placeholder = "Nombre y apellido"),
            div(class = "field-help", paste0("Máximo ", MAX_TEXTO, " caracteres.")),
            selectInput(
              "actividad_registro", "Actividad del servicio",
              choices = setNames(ACTIVIDADES_CAPTURA_ABIERTA$id, ACTIVIDADES_CAPTURA_ABIERTA$actividad),
              selected = ACTIVIDADES_CAPTURA_ABIERTA$id[1]
            ),
            selectInput(
              "bloque_registro", "Bloque temático",
              choices = setNames(BLOQUES_POR_ACTIVIDAD[[as.character(ACTIVIDADES_CAPTURA_ABIERTA$id[1])]], BLOQUES_POR_ACTIVIDAD[[as.character(ACTIVIDADES_CAPTURA_ABIERTA$id[1])]]),
              selected = BLOQUES_POR_ACTIVIDAD[[as.character(ACTIVIDADES_CAPTURA_ABIERTA$id[1])]][1]
            ),
            selectizeInput(
              "municipios", "Municipios donde se observó",
              choices = NULL, multiple = TRUE,
              options = list(create = TRUE, persist = FALSE, plugins = list("remove_button"), placeholder = "Escriba un municipio y presione Enter")
            ),
            textAreaInput("observacion", "Observación de campo", rows = 4, placeholder = "Describa concretamente qué se observó."),
            div(class = "field-help", paste0("Máximo ", MAX_OBSERVACION, " caracteres.")),
            tags$label(class = "control-label", "¿Cómo clasifica esta observación?"),
            div(
              id = "categorySelector", class = "category-grid category-grid-five",
              lapply(names(CATEGORIAS), function(key) {
                tags$button(
                  type = "button",
                  class = paste("category-btn", paste0("cat-", key)),
                  `data-category` = unname(CATEGORIAS[[key]]),
                  `aria-pressed` = "false",
                  unname(CATEGORIAS[[key]])
                )
              })
            ),
            div(class = "field-help", "Seleccione una sola clasificación."),
            textAreaInput("implicacion", "Implicación para el estudio", rows = 3, placeholder = "¿Qué debería revisar o analizar el estudio regulatorio?"),
            div(class = "field-help", paste0("Máximo ", MAX_IMPLICACION, " caracteres.")),
            actionButton("guardar_observacion", "Guardar observación", class = "btn-primary btn-lg full-action")
          )
        ),
        column(
          width = 7,
          uiOutput("contribution_metrics"),
          div(
            class = "panel-card",
            div(class = "section-heading", tags$h3("Participación por grupo"), tags$p("Permite verificar qué grupos ya aportaron en esta actividad.")),
            uiOutput("people_progress")
          ),
          div(
            class = "panel-card",
            div(
              class = "section-heading",
              div(
                tags$h3("Observaciones registradas"),
                tags$p("La lista permanece estable. Use Actualizar observaciones cuando quiera incorporar aportes nuevos.")
              ),
              actionButton("refresh_capture", "Actualizar observaciones", class = "btn-secondary")
            ),
            fluidRow(
              column(
                width = 3,
                selectInput(
                  "registered_activity", "Actividad",
                  choices = c("Todas" = "", setNames(ACTIVIDADES$id, ACTIVIDADES$actividad)),
                  selected = ""
                )
              ),
              column(
                width = 3,
                selectInput(
                  "registered_group", "Grupo / comisión",
                  choices = c("Todos" = "", setNames(COMISIONES, COMISIONES)),
                  selected = ""
                )
              ),
              column(
                width = 3,
                selectInput(
                  "registered_block", "Bloque temático",
                  choices = c("Todos" = "", setNames(sort(unique(unlist(BLOQUES_POR_ACTIVIDAD))), sort(unique(unlist(BLOQUES_POR_ACTIVIDAD))))),
                  selected = ""
                )
              ),
              column(
                width = 3,
                selectInput(
                  "registered_category", "Clasificación",
                  choices = c("Todas" = "", setNames(unname(CATEGORIAS), unname(CATEGORIAS))),
                  selected = ""
                )
              )
            ),
            uiOutput("registered_findings")
          )
        )
      )
    )
  ),

  tabPanel(
    "Consolidado",
    value = "consolidado",
    div(
      class = "page-wrap",
      div(
        class = "page-intro",
        div(class = "eyebrow", "CONSOLIDADO"),
        tags$h2("Consolidar observaciones"),
        tags$p("Las observaciones se agrupan únicamente por Actividad del servicio + Bloque temático. Esta pestaña no se recarga automáticamente mientras está leyendo o editando; use Actualizar consolidado cuando quiera incorporar aportes nuevos.")
      ),
      uiOutput("consolidation_ui")
    )
  ),

  tabPanel(
    "Priorización",
    value = "priorizacion",
    div(
      class = "page-wrap",
      div(
        class = "page-intro",
        div(class = "eyebrow", "PRIORIZACIÓN"),
        tags$h2("Priorizar conclusiones"),
        tags$p("Cada actividad se prioriza y se envía por separado. Seleccione una actividad, distribuya sus 5 puntos y envíe esa priorización antes de continuar con otra.")
      ),
      div(
        class = "question-card",
        div(class = "eyebrow", "PRIORIZACIÓN COLECTIVA"),
        tags$h2("¿Cuáles de estas conclusiones deberían ser analizadas necesariamente en el estudio regulatorio?"),
        tags$p("Seleccione una actividad y distribuya exactamente 5 puntos entre sus conclusiones. Puede enviar una actividad sin haber votado las demás.")
      ),
      div(
        class = "voter-toolbar panel-card",
        div(
          class = "row",
          div(
            class = "col-sm-6",
            tags$label(`for` = "participant_name_client", "Nombre del participante"),
            tags$input(
              id = "participant_name_client",
              type = "text",
              class = "form-control",
              placeholder = "Nombre y apellido",
              maxlength = MAX_TEXTO,
              autocomplete = "name"
            ),
            div(class = "field-help", paste0("Máximo ", MAX_TEXTO, " caracteres."))
          ),
          div(
            class = "col-sm-6",
            tags$label(`for` = "priority_activity_filter_client", "Actividad a priorizar"),
            tags$select(
              id = "priority_activity_filter_client",
              class = "form-control",
              tags$option(value = "", "Seleccione una actividad"),
              lapply(seq_len(nrow(ACTIVIDADES)), function(i) {
                tags$option(
                  value = as.character(ACTIVIDADES$id[i]),
                  as.character(ACTIVIDADES$actividad[i])
                )
              })
            ),
            div(class = "field-help", "Cada actividad tiene un envío independiente de 5 puntos. Puede volver a una actividad y reemplazar únicamente ese envío.")
          )
        )
      ),
      div(
        id = "voting_client_status",
        class = "voting-client-status",
        paste0(
          "Seleccione una actividad y asigne exactamente ", PUNTOS_POR_ACTIVIDAD,
          " puntos. El envío se guarda únicamente para la actividad seleccionada."
        )
      ),
      div(
        id = "pending_activities_panel",
        class = "pending-activities-panel",
        tags$div(class = "activity-picker-title", "Actividades pendientes por priorizar"),
        tags$div(class = "activity-picker-help", "Seleccione una actividad para continuar.")
      ),
      div(
        id = "voting_client_root",
        class = "voting-client-root",
        uiOutput("prioritization_cards_ui")
      ),
      div(
        class = "submit-vote-wrap",
        tags$button(
          id = "submit_votes_client",
          type = "button",
          class = "btn btn-primary btn-lg vote-submit",
          disabled = "disabled",
          "Enviar priorización"
        ),
        div(style = "display:none;", textOutput("vote_submit_ack"))
      )
    )
  ),

  tabPanel(
    "Resultados",
    value = "resultados",
    div(class = "page-wrap", uiOutput("results_ui"))
  ),

  footer = div(
    class = "app-footer",
    paste0("Modo: ", toupper(MODO_ALMACENAMIENTO), " · Zona horaria: ", ZONA_HORARIA, " · Captura, Consolidado y Resultados se actualizan manualmente")
  )
)

# ------------------------------------------------------------
# 15. SERVER
# ------------------------------------------------------------

server <- function(input, output, session) {

  # Captura usa una instantánea estable para evitar parpadeos y consultas repetidas.
  capture_obs <- reactiveVal(CACHE$observaciones)

  refresh_capture_snapshot <- function(force = TRUE) {
    refresh_cache(force)
    capture_obs(CACHE$observaciones)
    invisible(TRUE)
  }

  observeEvent(input$refresh_capture, {
    refresh_capture_snapshot(TRUE)
    showNotification("Observaciones actualizadas con los registros más recientes.", type = "message", duration = 3)
  }, ignoreInit = TRUE)

  # El Consolidado usa una instantánea estable. No depende del temporizador de 2 s,
  # para evitar que se cierren los <details> o se interrumpa la redacción.
  consolidation_obs <- reactiveVal(CACHE$observaciones)
  consolidation_conc <- reactiveVal(CACHE$conclusiones)

  # Resultados usa también una instantánea estable. No depende del temporizador
  # de 2 segundos para evitar parpadeos y recálculos constantes.
  results_obs <- reactiveVal(CACHE$observaciones)
  results_conc <- reactiveVal(CACHE$conclusiones)
  results_votes <- reactiveVal(CACHE$votos)

  refresh_consolidation_snapshot <- function(force = TRUE) {
    refresh_cache(force)
    consolidation_obs(CACHE$observaciones)
    consolidation_conc(CACHE$conclusiones)
    invisible(TRUE)
  }

  refresh_results_snapshot <- function(force = TRUE) {
    refresh_cache(force)
    results_obs(CACHE$observaciones)
    results_conc(CACHE$conclusiones)
    results_votes(CACHE$votos)
    invisible(TRUE)
  }

  observeEvent(input$refresh_consolidation, {
    refresh_consolidation_snapshot(TRUE)
    showNotification("Consolidado actualizado con los registros más recientes.", type = "message", duration = 3)
  }, ignoreInit = TRUE)

  # Al entrar a la pestaña Consolidado se toma una instantánea fresca una sola vez.
  # Después permanece estable hasta que el usuario pulse Actualizar consolidado o vuelva a entrar.
  observeEvent(input$main_tabs, {
    if (identical(input$main_tabs, "consolidado")) {
      refresh_consolidation_snapshot(TRUE)
    }
  }, ignoreInit = TRUE)

  observeEvent(session$clientData$url_search, {
    qs <- parseQueryString(session$clientData$url_search)
    aid <- suppressWarnings(as.integer(qs$actividad %||% NA))
    if (!is.na(aid) && aid %in% ACTIVIDADES_CAPTURA_ABIERTA$id) updateSelectInput(session, "actividad_registro", selected = aid)
  }, once = TRUE)

  observeEvent(input$comision_registro, {
    sugeridos <- GRUPOS_MUNICIPIOS[[input$comision_registro %||% ""]] %||% character(0)
    updateSelectizeInput(session, "municipios", choices = sugeridos, selected = character(0), server = FALSE)
  }, ignoreInit = FALSE)

  actualizar_bloques_registro <- function(aid) {
    aid <- as.character(aid %||% as.character(ACTIVIDADES_CAPTURA_ABIERTA$id[1]))
    bloques <- BLOQUES_POR_ACTIVIDAD[[aid]] %||% character(0)
    seleccionado <- if (length(bloques) > 0) bloques[1] else character(0)
    updateSelectInput(
      session,
      "bloque_registro",
      choices = setNames(bloques, bloques),
      selected = seleccionado
    )
  }

  observeEvent(input$actividad_registro, {
    actualizar_bloques_registro(input$actividad_registro)
  }, ignoreInit = FALSE)

  output$contribution_metrics <- renderUI({
    aid <- as.integer(input$actividad_registro %||% ACTIVIDADES_CAPTURA_ABIERTA$id[1])
    h <- capture_obs() %>% filter(actividad_id == aid)
    div(
      class = "metrics-grid three",
      metric_card("Observaciones", nrow(h)),
      metric_card("Grupos que aportaron", n_distinct(h$grupo_key)),
      metric_card("Bloques con aportes", n_distinct(h$bloque))
    )
  })

  output$people_progress <- renderUI({
    aid <- as.integer(input$actividad_registro %||% ACTIVIDADES_CAPTURA_ABIERTA$id[1])
    h <- capture_obs() %>% filter(actividad_id == aid)
    if (nrow(h) == 0) return(div(class = "empty-state", "Todavía no hay aportes en esta actividad."))
    x <- h %>% count(grupo, sort = TRUE, name = "aportes")
    tagList(lapply(seq_len(nrow(x)), function(i) {
      div(class = "progress-person", div(class = "progress-name", x$grupo[i]), div(class = "progress-count", paste(x$aportes[i], "aporte(s)")))
    }))
  })

  output$registered_findings <- renderUI({
    h <- capture_obs()

    aid_filter <- suppressWarnings(as.integer(input$registered_activity %||% NA))
    group_filter <- input$registered_group %||% ""
    block_filter <- input$registered_block %||% ""
    category_filter <- input$registered_category %||% ""

    if (!is.na(aid_filter)) h <- h %>% filter(actividad_id == aid_filter)
    if (nzchar(group_filter)) h <- h %>% filter(grupo == group_filter)
    if (nzchar(block_filter)) h <- h %>% filter(bloque == block_filter)
    if (nzchar(category_filter)) h <- h %>% filter(grepl(category_filter, categorias, fixed = TRUE))

    h <- h %>% arrange(desc(created_at))

    if (nrow(h) == 0) {
      return(div(class = "empty-state", "No hay observaciones que coincidan con los filtros seleccionados."))
    }

    tagList(lapply(seq_len(nrow(h)), function(i) {
      row <- h[i, ]
      div(
        class = "finding-card",
        div(
          class = "finding-topline",
          div(class = "badge-row", category_badges(row$categorias)),
          div(class = "finding-meta", paste(row$grupo, "·", row$persona, "·", format_fecha(row$created_at)))
        ),
        div(class = "finding-detail", tags$strong("Bloque: "), row$bloque),
        div(class = "finding-text", row$observacion),
        if (nzchar(row$municipios)) div(class = "finding-detail", tags$strong("Municipios: "), row$municipios),
        if (nzchar(row$implicacion)) div(class = "finding-detail", tags$strong("Implicación: "), row$implicacion)
      )
    }))
  })

  observeEvent(input$guardar_observacion, {
    grupo <- trimws(input$comision_registro %||% "")
    persona <- trimws(input$persona_registro %||% "")
    aid <- as.integer(input$actividad_registro %||% NA)
    bloque <- trimws(input$bloque_registro %||% "")
    observacion <- trimws(input$observacion %||% "")
    implicacion <- trimws(input$implicacion %||% "")
    municipios <- paste(input$municipios %||% character(0), collapse = " | ")
    cats <- input$selected_categories %||% character(0)

    errors <- character(0)
    if (!nzchar(grupo)) errors <- c(errors, "Seleccione la comisión / grupo.")
    if (!nzchar(persona)) errors <- c(errors, "Ingrese el nombre de quien registra.")
    if (is.na(aid) || !aid %in% ACTIVIDADES$id) errors <- c(errors, "Seleccione una actividad válida.")
    if (!is.na(aid) && aid %in% c(7L, 8L)) errors <- c(errors, "La captura de nuevas observaciones para Recolección y transporte y Barrido está cerrada.")
    if (!nzchar(bloque)) errors <- c(errors, "Seleccione el bloque temático.")
    if (!nzchar(observacion)) errors <- c(errors, "Escriba la observación de campo.")
    if (nchar(observacion, type = "chars") > MAX_OBSERVACION) errors <- c(errors, paste0("La observación puede tener máximo ", MAX_OBSERVACION, " caracteres."))
    if (nchar(persona, type = "chars") > MAX_TEXTO) errors <- c(errors, paste0("El nombre puede tener máximo ", MAX_TEXTO, " caracteres."))
    if (nchar(implicacion, type = "chars") > MAX_IMPLICACION) errors <- c(errors, paste0("La implicación puede tener máximo ", MAX_IMPLICACION, " caracteres."))
    if (length(input$municipios %||% character(0)) > 0 && any(nchar(input$municipios, type = "chars") > MAX_TEXTO)) errors <- c(errors, paste0("Cada municipio puede tener máximo ", MAX_TEXTO, " caracteres."))
    if (nchar(municipios, type = "chars") > MAX_TEXTO) errors <- c(errors, paste0("El conjunto de municipios puede tener máximo ", MAX_TEXTO, " caracteres."))
    if (length(cats) != 1) errors <- c(errors, "Seleccione exactamente una clasificación.")

    if (length(errors) > 0) {
      showNotification(paste(errors, collapse = " "), type = "error", duration = 8)
      return()
    }

    row <- tibble(
      id = uuid::UUIDgenerate(),
      actividad_id = aid,
      actividad = activity_name(aid),
      grupo = grupo,
      grupo_key = normalizar_nombre(grupo),
      persona = persona,
      persona_key = normalizar_nombre(persona),
      bloque = bloque,
      pregunta_codigo = "",
      pregunta_texto = "",
      observacion = observacion,
      categorias = paste(cats, collapse = " | "),
      municipios = municipios,
      implicacion = implicacion,
      created_at = now_bogota()
    )

    tryCatch({
      insert_observacion(row)
      refresh_capture_snapshot(TRUE)
      updateTextAreaInput(session, "observacion", value = "")
      updateTextAreaInput(session, "implicacion", value = "")
      updateSelectizeInput(session, "municipios", selected = character(0))
      session$sendCustomMessage("resetCategories", list())
      session$sendCustomMessage("rememberContributor", list(name = persona))
      showNotification("Observación guardada.", type = "message", duration = 4)
    }, error = function(e) {
      showNotification(paste("No se pudo guardar la observación:", conditionMessage(e)), type = "error", duration = 10)
    })
  })

  # ---------- CONSOLIDACIÓN ----------

  filtered_groups <- reactive({
    g <- build_group_summary(consolidation_obs())
    aid <- input$consolidation_activity %||% ""
    block <- input$consolidation_block %||% ""
    if (nzchar(aid)) g <- g %>% filter(actividad_id == as.integer(aid))
    if (nzchar(block)) g <- g %>% filter(bloque == block)
    g
  })

  output$consolidation_ui <- renderUI({
    tagList(
      fluidRow(
        column(4, selectInput("consolidation_activity", "Actividad", choices = c("Todas" = "", setNames(ACTIVIDADES$id, ACTIVIDADES$actividad)))),
        column(4, uiOutput("consolidation_block_filter")),
        column(4, div(class = "consolidation-refresh-wrap", actionButton("refresh_consolidation", "Actualizar consolidado", icon = icon("refresh"), class = "btn-primary full-action")))
      ),
      div(class = "field-help consolidation-refresh-help", "Mientras permanezca en esta pantalla, las tarjetas no se recargan solas. Esto mantiene abiertas las observaciones y evita interrumpir la edición."),
      uiOutput("consolidation_metrics"),
      uiOutput("consolidation_groups")
    )
  })

  output$consolidation_block_filter <- renderUI({
    aid <- input$consolidation_activity %||% ""
    blocks <- if (nzchar(aid)) BLOQUES_POR_ACTIVIDAD[[aid]] %||% character(0) else unique(unlist(BLOQUES_POR_ACTIVIDAD, use.names = FALSE))
    selectInput("consolidation_block", "Bloque temático", choices = c("Todos" = "", setNames(blocks, blocks)))
  })

  output$consolidation_metrics <- renderUI({
    g <- build_group_summary(consolidation_obs())
    c <- consolidation_conc()
    div(
      class = "metrics-grid four",
      metric_card("Bloques con aportes", nrow(g)),
      metric_card("Conclusiones", nrow(c)),
      metric_card("Conclusiones", nrow(c)),
      metric_card("Observaciones capturadas", nrow(consolidation_obs()))
    )
  })

  output$consolidation_groups <- renderUI({
    g <- filtered_groups()
    obs <- consolidation_obs()
    conc <- consolidation_conc()
    if (nrow(g) == 0) return(div(class = "empty-state large", "No hay observaciones para los filtros seleccionados."))

    tagList(lapply(seq_len(nrow(g)), function(i) {
      row <- g[i, ]
      source <- obs %>% filter(actividad_id == row$actividad_id, bloque == row$bloque) %>% arrange(created_at)
      cc <- conc %>% filter(group_key == row$group_key) %>% arrange(id)

      div(
        class = "consolidation-card panel-card",
        div(
          class = "consolidation-title-row",
          div(
            div(class = "eyebrow", row$actividad),
            tags$h3(row$bloque),
            div(class = "badge-row", category_badges(row$categorias))
          ),
          div(class = "mini-kpis", tags$span(paste(row$n_observaciones, "observaciones")), tags$span(paste(row$n_grupos, "grupos")))
        ),
        div(
          class = "analysis-grid",
          div(class = "analysis-box", tags$strong("Palabras más frecuentes"), tags$p(row$palabras_frecuentes)),
          div(class = "analysis-box", tags$strong("Municipios mencionados"), tags$p(ifelse(nzchar(row$municipios), row$municipios, "Sin municipios")))
        ),
        div(class = "auto-summary", tags$strong("Síntesis descriptiva automática"), tags$p(row$sintesis_preliminar)),
        div(
          class = "source-observations",
          tagList(lapply(seq_len(nrow(source)), function(j) {
            src <- source[j, ]
            tags$details(
              class = "source-observation",
              tags$summary(
                div(
                  class = "source-observation-preview",
                  div(
                    class = "source-observation-preview-head",
                    tags$span(class = "source-observation-number", paste0("Observación ", j)),
                    tags$span(class = "source-observation-categories", category_badges(src$categorias))
                  ),
                  tags$p(class = "source-observation-preview-text", src$observacion),
                  tags$p(
                    class = "source-observation-preview-implication",
                    tags$strong("Implicación: "),
                    ifelse(nzchar(src$implicacion), src$implicacion, "Sin implicación registrada")
                  ),
                  tags$small(class = "source-observation-preview-group", paste0("Aporte: ", src$grupo))
                )
              ),
              div(
                class = "source-observation-body",
                div(class = "source-meta-grid",
                    div(class = "source-meta-box", tags$strong("Quién la registró"), tags$p(src$persona)),
                    div(class = "source-meta-box", tags$strong("Comisión / grupo"), tags$p(src$grupo)),
                    div(class = "source-meta-box", tags$strong("Clasificación"), div(class = "badge-row", category_badges(src$categorias))),
                    div(class = "source-meta-box", tags$strong("Fecha"), tags$p(format_fecha(src$created_at)))
                ),
                div(class = "source-full-field source-main-text", tags$strong("Observación registrada"), tags$p(src$observacion)),
                div(class = "source-meta-grid",
                    div(class = "source-meta-box", tags$strong("Municipios"), tags$p(ifelse(nzchar(src$municipios), src$municipios, "Sin municipios registrados"))),
                    div(class = "source-meta-box", tags$strong("Implicación para el estudio"), tags$p(ifelse(nzchar(src$implicacion), src$implicacion, "Sin implicación registrada")))
                )
              )
            )
          }))
        ),
        div(
          class = "conclusions-section",
          div(
            class = "section-heading",
            tags$h4("Conclusiones del bloque"),
            tags$button(type = "button", class = "btn btn-primary conclusion-action-btn", `data-mode` = "add", `data-key` = row$group_key, "Agregar conclusión")
          ),
          if (nrow(cc) == 0) {
            div(class = "empty-state compact", "Todavía no hay conclusiones para este bloque.")
          } else {
            tagList(lapply(seq_len(nrow(cc)), function(k) {
              cr <- cc[k, ]
              div(
                class = "conclusion-item",
                div(
                  class = "conclusion-item-top",
                  tags$strong(paste0("Conclusión ", k))
                ),
                tags$p(cr$conclusion),
                div(class = "save-meta", format_fecha(cr$updated_at)),
                tags$button(type = "button", class = "btn btn-default conclusion-action-btn", `data-mode` = "edit", `data-id` = cr$id, `data-key` = row$group_key, "Editar conclusión")
              )
            }))
          }
        )
      )
    }))
  })

  conclusion_modal_context <- reactiveVal(NULL)

  observeEvent(input$conclusion_action, {
    req(input$conclusion_action$mode)
    mode <- input$conclusion_action$mode
    key <- as.character(input$conclusion_action$key %||% "")
    cid <- as.character(input$conclusion_action$id %||% "")

    g <- build_group_summary(consolidation_obs()) %>% filter(group_key == key)
    if (nrow(g) == 0) return()
    g <- g[1, ]

    if (mode == "edit") {
      c0 <- consolidation_conc() %>% filter(id == cid)
      if (nrow(c0) == 0) return()
      c0 <- c0[1, ]
      value <- c0$conclusion
    } else {
      value <- ""
      cid <- ""
    }

    conclusion_modal_context(list(mode = mode, key = key, id = cid, group = g))

    showModal(modalDialog(
      title = if (mode == "edit") "Editar conclusión" else "Agregar conclusión",
      textAreaInput("modal_conclusion", "Conclusión", value = value, rows = 6, width = "100%", placeholder = "Redacte una conclusión clara y concreta para este bloque."),
      div(class = "field-help", paste0("Máximo ", MAX_TEXTO, " caracteres.")),
      easyClose = FALSE,
      footer = tagList(modalButton("Cancelar"), actionButton("save_conclusion_modal", "Guardar conclusión", class = "btn-primary"))
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$save_conclusion_modal, {
    ctx <- conclusion_modal_context(); req(ctx)
    text <- trimws(input$modal_conclusion %||% "")
    person <- "Consolidación"
    enabled <- TRUE

    if (!nzchar(text)) {
      showNotification("Escriba la conclusión.", type = "error")
      return()
    }
    if (nchar(text, type = "chars") > MAX_TEXTO) {
      showNotification(paste0("La conclusión puede tener máximo ", MAX_TEXTO, " caracteres."), type = "error")
      return()
    }

    g <- ctx$group
    row <- tibble(
      id = if (ctx$mode == "add") uuid::UUIDgenerate() else ctx$id,
      group_key = g$group_key,
      actividad_id = g$actividad_id,
      actividad = g$actividad,
      bloque = g$bloque,
      conclusion = text,
      habilitada_votacion = enabled,
      actualizado_por = person,
      updated_at = now_bogota()
    )

    tryCatch({
      save_conclusion(row, ctx$mode)
      refresh_consolidation_snapshot(TRUE)
      removeModal()
      conclusion_modal_context(NULL)
      showNotification("Conclusión guardada.", type = "message", duration = 4)
    }, error = function(e) {
      showNotification(paste("No se pudo guardar la conclusión:", conditionMessage(e)), type = "error", duration = 10)
    })
  })

  # ---------- PRIORIZACIÓN ----------

  # La caché de conclusiones es compartida por las sesiones del mismo worker.

  get_prioritization_conclusions <- function(force = FALSE) {
    now <- Sys.time()
    fresh <- nrow(PRIORITY_CACHE$conclusiones) > 0 &&
      as.numeric(difftime(now, PRIORITY_CACHE$last_refresh, units = "secs")) < PRIORITY_CACHE_TTL

    if (!force && fresh) return(PRIORITY_CACHE$conclusiones)

    x <- if (MODO_ALMACENAMIENTO == "local") read_local_conclusiones() else read_postgres_conclusiones()
    PRIORITY_CACHE$conclusiones <- x
    PRIORITY_CACHE$last_refresh <- now
    x
  }

  session_votable <- reactiveVal(empty_conclusiones())

  # Canal de confirmación robusto para el navegador. A diferencia de un mensaje
  # personalizado, este output forma parte del protocolo normal de Shiny y permite
  # liberar cada actividad aunque falle un handler JavaScript personalizado.
  vote_submit_ack <- reactiveVal("")
  output$vote_submit_ack <- renderText(vote_submit_ack())
  outputOptions(output, "vote_submit_ack", suspendWhenHidden = FALSE)

  output$prioritization_cards_ui <- renderUI({
    # Una sola construcción por sesión. La lectura usa caché compartida por worker.
    c <- get_prioritization_conclusions(FALSE) %>%
      filter(habilitada_votacion, nzchar(conclusion)) %>%
      arrange(actividad_id, bloque, id)

    session_votable(c)

    if (nrow(c) == 0) {
      return(div(class = "empty-state",
                 "Todavía no hay conclusiones habilitadas para priorización."))
    }

    tagList(lapply(seq_len(nrow(ACTIVIDADES)), function(i) {
      aid <- as.integer(ACTIVIDADES$id[i])
      actividad_nombre <- as.character(ACTIVIDADES$actividad[i])
      ca <- c %>% filter(actividad_id == aid)

      div(
        class = "activity-vote-section",
        `data-activity-id` = as.character(aid),
        `data-activity-name` = actividad_nombre,
        `data-points-limit` = as.character(PUNTOS_POR_ACTIVIDAD),
        `data-has-conclusions` = if (nrow(ca) > 0) "true" else "false",

        div(
          class = "voting-activity-header",
          tags$h3(actividad_nombre),
          div(
            class = "points-box activity-points-counter",
            `data-activity-counter` = as.character(aid),
            div(class = "points-big", as.character(PUNTOS_POR_ACTIVIDAD)),
            div(class = "points-label", "puntos restantes"),
            div(class = "points-small",
                paste0("0 de ", PUNTOS_POR_ACTIVIDAD, " asignados"))
          )
        ),

        if (nrow(ca) == 0) {
          div(class = "empty-state", "No hay conclusiones disponibles en esta actividad.")
        } else {
          tagList(lapply(seq_len(nrow(ca)), function(j) {
            conclusion_id <- as.character(ca$id[j])
            div(
              class = "finding-card vote-card",
              div(class = "finding-topline",
                  div(class = "finding-meta", as.character(ca$bloque[j]))),
              div(class = "finding-text", as.character(ca$conclusion[j])),
              div(
                class = "vote-control",
                tags$button(
                  type = "button", class = "vote-btn vote-minus",
                  `data-vote-local` = "true",
                  `data-id` = conclusion_id,
                  `data-delta` = "-1",
                  `data-activity-id` = as.character(aid),
                  `aria-label` = "Quitar un punto",
                  disabled = "disabled", "−"
                ),
                div(class = "vote-number",
                    `data-vote-number` = conclusion_id,
                    `aria-live` = "polite", "0"),
                tags$button(
                  type = "button", class = "vote-btn vote-plus",
                  `data-vote-local` = "true",
                  `data-id` = conclusion_id,
                  `data-delta` = "1",
                  `data-activity-id` = as.character(aid),
                  `aria-label` = "Agregar un punto", "+"
                )
              )
            )
          }))
        }
      )
    }))
  })

  outputOptions(output, "prioritization_cards_ui", suspendWhenHidden = TRUE)

  observeEvent(input$main_tabs, {
    if (identical(input$main_tabs, "resultados")) {
      refresh_results_snapshot(TRUE)
    }
  }, ignoreInit = TRUE)

  observeEvent(input$refresh_results, {
    refresh_results_snapshot(TRUE)
    showNotification("Resultados actualizados con la información más reciente.", type = "message", duration = 3)
  }, ignoreInit = TRUE)

  normalize_client_votes <- function(votes) {
    if (is.null(votes) || length(votes) == 0) {
      return(tibble(conclusion_id = character(), puntos = integer()))
    }

    if (is.data.frame(votes)) {
      out <- tibble(
        conclusion_id = as.character(votes$id),
        puntos = as.integer(votes$puntos)
      )
    } else {
      rows <- lapply(votes, function(v) {
        if (is.null(v$id) || is.null(v$puntos)) return(NULL)
        tibble(conclusion_id = as.character(v$id), puntos = as.integer(v$puntos))
      })
      rows <- Filter(Negate(is.null), rows)
      if (length(rows) == 0) return(tibble(conclusion_id = character(), puntos = integer()))
      out <- bind_rows(rows)
    }

    out %>%
      filter(!is.na(puntos), puntos > 0, nzchar(conclusion_id)) %>%
      group_by(conclusion_id) %>%
      summarise(puntos = sum(puntos), .groups = "drop")
  }

  make_vote_rows <- function(participant, actividad_id, vote_items) {
    envio_id <- uuid::UUIDgenerate()
    tibble(
      id = vapply(seq_len(nrow(vote_items)), function(i) uuid::UUIDgenerate(), character(1)),
      envio_id = envio_id,
      participante = trimws(participant),
      participante_key = vote_participant_key(participant, actividad_id),
      conclusion_id = as.character(vote_items$conclusion_id),
      puntos = as.integer(vote_items$puntos),
      submitted_at = now_bogota()
    )
  }

  validate_activity_vote <- function(vote_items, actividad_id) {
    c <- session_votable()
    if (nrow(c) == 0) stop("No hay conclusiones disponibles para priorización.")

    actividad_id <- as.integer(actividad_id)
    if (is.na(actividad_id) || !(actividad_id %in% ACTIVIDADES$id)) {
      stop("Seleccione una actividad válida.")
    }

    joined <- vote_items %>%
      left_join(c %>% transmute(conclusion_id = as.character(id), actividad_id), by = "conclusion_id")
    if (anyNA(joined$actividad_id)) stop("Una de las conclusiones ya no está disponible para priorización.")
    if (any(as.integer(joined$actividad_id) != actividad_id)) {
      stop("El envío contiene conclusiones de otra actividad.")
    }

    total <- sum(as.integer(joined$puntos), na.rm = TRUE)
    if (total != as.integer(PUNTOS_POR_ACTIVIDAD)) {
      stop(
        "Debe asignar exactamente ", PUNTOS_POR_ACTIVIDAD,
        " puntos en ", activity_name(actividad_id), "."
      )
    }
    invisible(TRUE)
  }

  save_client_vote <- function(participant, actividad_id, vote_items) {
    rows <- make_vote_rows(participant, actividad_id, vote_items)

    # Validación de actividad también se hace localmente; PostgreSQL vuelve a
    # comprobar los 5 puntos dentro de la misma transacción.
    validate_activity_vote(vote_items, actividad_id)
    insert_votos(rows)

    showNotification(
      paste0(
        "Priorización de ", activity_name(actividad_id),
        " enviada correctamente (", PUNTOS_POR_ACTIVIDAD, " puntos)."
      ),
      type = "message", duration = 6
    )
    invisible(TRUE)
  }

  observeEvent(input$vote_submit_client, {
    payload <- input$vote_submit_client
    nonce <- as.character(payload$nonce %||% "")
    actividad_hint <- suppressWarnings(as.integer(payload$activity_id %||% NA_integer_))

    send_vote_ack <- function(status) {
      aid <- if (is.na(actividad_hint)) "" else as.character(actividad_hint)
      vote_submit_ack(paste(nonce, aid, status, sep = "|"))
    }

    tryCatch({
      participant <- trimws(as.character(payload$participant %||% ""))
      actividad_id <- suppressWarnings(as.integer(payload$activity_id %||% NA_integer_))
      vote_items <- normalize_client_votes(payload$votes)

      if (!nzchar(participant)) stop("Escriba su nombre antes de enviar la priorización.")
      if (nchar(participant, type = "chars") > MAX_TEXTO) {
        stop(paste0("El nombre puede tener máximo ", MAX_TEXTO, " caracteres."))
      }
      if (is.na(actividad_id) || !(actividad_id %in% ACTIVIDADES$id)) {
        stop("Seleccione la actividad que desea priorizar.")
      }
      if (nrow(vote_items) == 0) stop("No se recibieron puntos para guardar.")

      actividad_hint <- actividad_id
      save_client_vote(participant, actividad_id, vote_items)
      send_vote_ack("ok")
    }, error = function(e) {
      send_vote_ack("error")
      showNotification(
        paste("No se pudo guardar la priorización:", conditionMessage(e)),
        type = "error", duration = 12
      )
    })
  })

  # ---------- RESULTADOS ----------

  output$results_ui <- renderUI({
    tagList(
      div(class = "results-header", tags$h2("Resultados consolidados"), tags$p("Resultados de las conclusiones habilitadas para priorización.")),
      fluidRow(
        column(3, numericInput("top_n", "Conclusiones a priorizar", value = N_PRIORIZADOS_DEFAULT, min = 1, max = 100)),
        column(4, selectInput("results_activity", "Filtrar por actividad", choices = c("Todas" = "", setNames(ACTIVIDADES$id, ACTIVIDADES$actividad)))),
        column(2, br(), actionButton("refresh_results", "Actualizar resultados", icon = icon("refresh"), class = "btn-primary full-action")),
        column(3, br(), downloadButton("download_excel", "Descargar Excel completo", class = "btn-success btn-lg full-action"))
      ),
      div(class = "field-help consolidation-refresh-help", "Los resultados permanecen estables mientras consulta esta pantalla. Pulse Actualizar resultados para incorporar votos o conclusiones nuevos."),
      uiOutput("general_metrics"),
      div(class = "panel-card", tags$h3("Resumen por actividad"), tableOutput("activity_summary")),
      div(class = "panel-card", tags$h3("Ranking de conclusiones"), tableOutput("ranking_table"))
    )
  })

  current_top_n <- reactive(as.integer(input$top_n %||% N_PRIORIZADOS_DEFAULT))
  ranking_results <- reactive(build_ranking(results_conc(), results_votes(), current_top_n()))

  output$general_metrics <- renderUI({
    latest <- latest_vote_rows(results_votes())
    voters <- n_distinct(base_vote_participant_key(latest$participante_key))
    emitted <- sum(latest$puntos, na.rm = TRUE)
    expected <- N_PARTICIPANTES_ESPERADOS * PUNTOS_TOTALES_POR_PERSONA
    c <- results_conc()
    div(
      class = "metrics-grid four",
      metric_card("Observaciones capturadas", nrow(results_obs())),
      metric_card("Conclusiones", nrow(c), paste(sum(c$habilitada_votacion), "habilitadas para votar")),
      metric_card("Personas que votaron", paste0(voters, " / ", N_PARTICIPANTES_ESPERADOS)),
      metric_card("Puntos emitidos", paste0(emitted, " / ", expected))
    )
  })

  output$activity_summary <- renderTable({
    g <- build_group_summary(results_obs())
    c <- results_conc()
    r <- ranking_results()

    base <- tibble(actividad_id = ACTIVIDADES$id, Actividad = ACTIVIDADES$actividad) %>%
      left_join(g %>% group_by(actividad_id) %>% summarise(
        Observaciones = sum(n_observaciones),
        `Bloques con aportes` = n(),
        .groups = "drop"
      ), by = "actividad_id") %>%
      left_join(c %>% group_by(actividad_id) %>% summarise(
        Conclusiones = n(),
        `Habilitadas para votar` = sum(habilitada_votacion),
        .groups = "drop"
      ), by = "actividad_id") %>%
      left_join(r %>% group_by(actividad_id) %>% summarise(
        Puntos = sum(puntos),
        Priorizadas = sum(priorizado),
        .groups = "drop"
      ), by = "actividad_id") %>%
      mutate(across(where(is.numeric), ~coalesce(.x, 0L))) %>%
      select(-actividad_id)
    base
  }, striped = TRUE, bordered = FALSE, spacing = "s", width = "100%")

  output$ranking_table <- renderTable({
    x <- ranking_results()
    aid <- input$results_activity %||% ""
    if (nzchar(aid)) x <- x %>% filter(actividad_id == as.integer(aid))
    x %>% transmute(
      `Pos. general` = posicion_general,
      `Pos. actividad` = posicion_actividad,
      Actividad = actividad,
      `Bloque temático` = bloque,
      Conclusión = conclusion,
      Puntos = puntos,
      Priorizada = ifelse(priorizado, "Sí", "No")
    )
  }, striped = TRUE, bordered = FALSE, spacing = "s", width = "100%")

  output$download_excel <- downloadHandler(
    filename = function() paste0("Observaciones_taller_", format(Sys.Date(), "%Y-%m-%d"), ".xlsx"),
    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    content = function(file) {
      refresh_cache(TRUE)
      g <- build_group_summary(CACHE$observaciones)
      r <- build_ranking(CACHE$conclusiones, CACHE$votos, current_top_n())
      crear_excel_resultados(file, CACHE$observaciones, g, CACHE$conclusiones, CACHE$votos, r)
    }
  )
}

onStop(function() {
  if (!is.null(DB_POOL)) try(pool::poolClose(DB_POOL), silent = TRUE)
})

shinyApp(ui, server)

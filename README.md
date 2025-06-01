Projeto: Pipeline de Dados com DBT + DuckDB

Este projeto implementa um pipeline de dados utilizando o dbt (Data Build Tool) com o DuckDB como engine local. O pipeline processa dados brutos em camadas (raw → bronze → silver → gold), com organização modular e testes de qualidade.
✅ Etapas Realizadas
1. Instalação do Ambiente e Criação do Projeto

# Instale o dbt com suporte a DuckDB
pip install dbt-duckdb

# Crie o projeto dbt
dbt init meu_pipeline_duckdb
cd meu_pipeline_duckdb

2. Estrutura Inicial de Pastas e Models

mkdir -p models/raw models/bronze models/silver models/gold

3. Carga do Dado Bruto (Raw)

Criado o arquivo raw_data.csv com o conteúdo:

id,name,age
1,John,25
2,Jane,30
3,Bob,35

E o modelo load_raw_data.sql:

-- Carregar os dados do arquivo CSV para a tabela no DuckDB
SELECT * 
FROM read_csv_auto('/home/magno/dados/raw_data.csv')

4. Transformação Bronze

Arquivo: models/bronze/transform_data.sql

WITH raw AS (
    SELECT * FROM {{ ref('my_first_dbt_model') }}
)
SELECT
    id,
    UPPER(name) AS cleaned_name,  -- Transformação de nome para maiúsculas
    age
FROM raw

5. Transformação Silver

Arquivo: models/silver/enriched_data.sql

WITH bronze_data AS (
    SELECT * FROM {{ ref('transform_data') }}
)
SELECT
    id,
    cleaned_name,
    age,
    CASE 
        WHEN age < 30 THEN 'young'
        WHEN age BETWEEN 30 AND 40 THEN 'adult'
        ELSE 'senior'
    END AS age_group,
    COUNT(id) OVER (PARTITION BY 
        CASE 
            WHEN age < 30 THEN 'young'
            WHEN age BETWEEN 30 AND 40 THEN 'adult'
            ELSE 'senior'
        END
    ) AS age_count
FROM bronze_data

6. Agregação Gold

Arquivo: models/gold/summarized_data.sql

WITH silver_data AS (
    SELECT * FROM {{ ref('enriched_data') }}
)
SELECT
    age_group,
    SUM(age_count) AS total_count
FROM silver_data
GROUP BY age_group

7. Execução dos Models

dbt run

Se aparecer erro de modelo duplicado, a solução sugerida é:

rm -rf models/example
# Ou renomear os arquivos duplicados

8. Execução dos Testes de Qualidade de Dados

Após rodar os modelos, execute os testes de qualidade com:

dbt test

Resultado dos Testes:

PASS=12  WARN=0  ERROR=0  SKIP=0  TOTAL=12

Testes realizados:

    not_null: validação de colunas obrigatórias

    unique: validação de chaves únicas

    accepted_values: verificação de valores esperados

Todos os testes passaram, garantindo a integridade e qualidade dos dados.
9. Visualização da Lineage (opcional)

dbt docs generate
dbt docs serve

Depois, acesse no navegador o link informado (ex: http://localhost:8000).
✅ Status Final

Todos os modelos criados com sucesso, sem erros.
🔗 Tecnologias Utilizadas

    dbt-duckdb

    DuckDB local

    SQL (camadas de transformação)

    Lineage via dbt docs

👤 Autor

Magno – Pipeline local com dbt + DuckDB.
Projeto: Pipeline de Dados com DBT + DuckDB

Este projeto implementa um pipeline de dados utilizando o dbt (Data Build Tool) com o DuckDB como engine local. O pipeline segue a arquitetura em camadas (raw → bronze → silver → gold), com organização modular, transformações SQL e testes de qualidade de dados.
✅ Etapas Realizadas
1. Instalação do Ambiente e Criação do Projeto

# Instale o dbt com suporte ao DuckDB
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

Model criado: models/raw/load_raw_data.sql

-- Carregar os dados do arquivo CSV para o DuckDB
SELECT * 
FROM read_csv_auto('/home/magno/dados/raw_data.csv')

4. Transformação Bronze

Model: models/bronze/transform_data.sql

WITH raw AS (
    SELECT * FROM {{ ref('my_first_dbt_model') }}
)
SELECT
    id,
    UPPER(name) AS cleaned_name,  -- Nome em maiúsculas
    age
FROM raw

5. Transformação Silver

Model: models/silver/enriched_data.sql

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
    COUNT(id) OVER (
        PARTITION BY 
            CASE 
                WHEN age < 30 THEN 'young'
                WHEN age BETWEEN 30 AND 40 THEN 'adult'
                ELSE 'senior'
            END
    ) AS age_count
FROM bronze_data

6. Agregação Gold

Model: models/gold/summarized_data.sql

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

    Caso apareça erro de modelo duplicado, execute:

rm -rf models/example

Ou renomeie os arquivos conflitantes.
8. Execução dos Testes de Qualidade de Dados

dbt test

Resultado esperado:

PASS=12  WARN=0  ERROR=0  SKIP=0  TOTAL=12

Testes aplicados:

    not_null: Validação de colunas obrigatórias

    unique: Validação de chaves únicas

    accepted_values: Verificação de valores esperados

✅ Todos os testes foram aprovados.
9. Visualização da Lineage (Opcional)

dbt docs generate
dbt docs serve

Acesse no navegador o link informado (exemplo: http://localhost:8000) para visualizar o lineage dos modelos.
✅ Status Final

Todos os modelos foram criados com sucesso, e os testes de qualidade foram aprovados.
🔗 Tecnologias Utilizadas

    dbt-duckdb

    DuckDB (local)

    SQL (transformações em camadas)

    Documentação e Lineage com dbt docs

👤 Autor

Magno – Pipeline local com dbt + DuckDB
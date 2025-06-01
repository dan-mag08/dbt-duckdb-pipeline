 🚀 Projeto: Pipeline de Dados com DBT + DuckDB

Este projeto demonstra a construção de um pipeline de dados local utilizando o **[dbt (Data Build Tool)](https://www.getdbt.com/)** em conjunto com o **[DuckDB](https://duckdb.org/)**.  
O fluxo segue o modelo em camadas:  
**Raw → Bronze → Silver → Gold**, com organização modular, transformações SQL e testes automatizados de qualidade.

---

## ✅ Etapas Realizadas

### 1. 🔧 Instalação do Ambiente

```bash
# Instalar o dbt com suporte ao DuckDB
pip install dbt-duckdb

# Criar um novo projeto dbt
dbt init meu_pipeline_duckdb
cd meu_pipeline_duckdb

2. 📁 Estrutura de Diretórios

mkdir -p models/raw models/bronze models/silver models/gold

3. 🗂️ Carga de Dados Brutos (Raw)

Criado o arquivo raw_data.csv com o conteúdo:

id,name,age
1,John,25
2,Jane,30
3,Bob,35

Model: models/raw/load_raw_data.sql

-- Carrega os dados do CSV usando DuckDB
SELECT * 
FROM read_csv_auto('/home/magno/dados/raw_data.csv')

4. 🥉 Transformação Bronze

Model: models/bronze/transform_data.sql

WITH raw AS (
    SELECT * FROM {{ ref('my_first_dbt_model') }}
)
SELECT
    id,
    UPPER(name) AS cleaned_name,
    age
FROM raw

    Transformação: nome convertido para letras maiúsculas.

5. 🥈 Transformação Silver

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

    Categorização por faixa etária e contagem por grupo.

6. 🥇 Agregação Gold

Model: models/gold/summarized_data.sql

WITH silver_data AS (
    SELECT * FROM {{ ref('enriched_data') }}
)
SELECT
    age_group,
    SUM(age_count) AS total_count
FROM silver_data
GROUP BY age_group

    Agregação final dos dados por grupo etário.

7. ▶️ Execução do Pipeline

dbt run

💡 Se aparecer erro de modelo duplicado:

rm -rf models/example
# ou renomeie os arquivos duplicados

8. 🧪 Testes de Qualidade de Dados

dbt test

Resultado esperado:

PASS=12  WARN=0  ERROR=0  SKIP=0  TOTAL=12

Testes aplicados:

    not_null: Colunas obrigatórias

    unique: Chaves únicas

    accepted_values: Valores esperados

✅ Todos os testes passaram, garantindo a integridade dos dados.
9. 📊 Visualização da Lineage (opcional)

dbt docs generate
dbt docs serve

Acesse no navegador o link exibido (ex: http://localhost:8000) para navegar na documentação interativa.
📌 Status Final

✔️ Pipeline implementado com sucesso
✔️ Testes aprovados
✔️ Lineage disponível via dbt docs
🔗 Tecnologias Utilizadas

    dbt-duckdb

    DuckDB (engine local)

    SQL (transformações em camadas)

    Visualização com dbt docs

👤 Autor

Magno
Pipeline local com dbt + DuckDB
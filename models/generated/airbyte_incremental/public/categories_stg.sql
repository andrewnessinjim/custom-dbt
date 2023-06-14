{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('categories_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'category_name',
        'category_id',
        'modified_date',
    ]) }} as _airbyte_categories_hashid,
    tmp.*
from {{ ref('categories_ab2') }} tmp
-- categories
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}


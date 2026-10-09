{#- Use the folder schema as-is (staging, intermediate, marts) instead of prefixing the target schema. -#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ custom_schema_name if custom_schema_name else target.schema }}
{%- endmacro %}

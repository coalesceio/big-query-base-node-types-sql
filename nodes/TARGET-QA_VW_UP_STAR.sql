@id("f6a7b8c9-4d5e-4f6a-8b1c-2d3e4f5a6b73")
@nodeType("SQLFact")
@materializationType("view")
@description("QA view with SELECT * over the upstream table - Coalesce expands * at compile time, so an upstream column change should redeploy this view")
SELECT *
FROM {{ ref('TARGET', 'QA_VW_UP_SRC') }} `S`

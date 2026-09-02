@id("92c19493-fed2-4e72-918f-38e55843efbd")
@nodeType("705")
SELECT
     `N_NATIONKEY` AS `N_NATIONKEY` @inHash("GH_DEFAULT", 1),
     `N_NAME` AS `N_NAME` @inHash("GH_MD5", 1),
     `N_REGIONKEY` AS `N_REGIONKEY` @inHash("GH_SHA256", 1),
     `N_COMMENT` AS `N_COMMENT` @inHash("GH_CUSTOM_DELIM", 1),
     `N_NATIONKEY` AS `N_NATIONKEY_MULTI1` @inHash("GH_MULTI", 1),
     `N_NAME` AS `N_NAME_MULTI1` @inHash("GH_MULTI", 2),
     `N_REGIONKEY` AS `N_REGIONKEY_MULTI2` @inHash("GH_MULTI2", 1),
     `N_COMMENT` AS `N_COMMENT_MULTI2` @inHash("GH_MULTI2", 2),
     `last_modified` AS `last_modified`,

     -- Default hash macro usage (algo defaults to SHA1)
     CAST({{ get_hash('GH_DEFAULT') }} AS STRING) AS `GH_DEFAULT_HASH`,

     -- Hash macro with MD5 algorithm
     CAST({{ get_hash('GH_MD5', 'MD5') }} AS STRING) AS `GH_MD5_HASH`,

     -- Hash macro with SHA256 algorithm
     CAST({{ get_hash('GH_SHA256', 'SHA256') }} AS STRING) AS `GH_SHA256_HASH`,

     -- Hash macro with SHA256 algorithm and a custom delimiter
     CAST({{ get_hash('GH_CUSTOM_DELIM', algo='SHA256', delimiter='~') }} AS STRING) AS `GH_CUSTOM_DELIM_HASH`,

     -- Hash macro combining multiple keys into a single hash
     CAST({{ get_hash('GH_MULTI') }} AS STRING) AS `GH_MULTI_HASH`,

     -- Second, independent hash group combined with its own delimiter
     CAST({{ get_hash('GH_MULTI2', delimiter='~') }} AS STRING) AS `GH_MULTI2_HASH`,

     -- Explicit hash expression, not using the get_hash macro
     CAST(
       TO_HEX(
         SHA1(
           IFNULL(CAST(`N_NATIONKEY` AS STRING), 'null')
         )
       ) AS STRING
     ) AS `GH_EXPLICIT_HASH`
FROM {{ ref('SRC', 'nation') }} `nation`

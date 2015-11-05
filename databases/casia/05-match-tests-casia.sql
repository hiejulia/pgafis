\timing on

-- matching threshold set to: 40

-- =========================================================

-- Verification (1:1)

-- single logical answer for matching
SELECT (bz_match(a.mdt, b.mdt) >= 40) AS match
FROM casia a, casia b
WHERE a.fp = '001_L0_0'
  AND b.fp = '001_L0_1';

/*
 match 
-------
 t
(1 row)
*/

-- matching along with score value
SELECT score, (score >= 40) AS match
FROM (
  SELECT bz_match(a.mdt, b.mdt) AS score
  FROM casia a, casia b
  WHERE a.id = 1 AND b.id = 2
) a;

/*
 score | match 
-------+-------
   103 | t
(1 row)
*/

-- =========================================================

-- Identification (1:N)

-- all matching occurrences scored
SELECT a.fp AS probe, b.fp AS sample,
  bz_match(a.mdt, b.mdt) AS score
FROM casia a, casia b
WHERE a.fp = '001_L0_0'
  AND b.fp != a.fp
  AND bz_match(a.mdt, b.mdt) >= 40
ORDER BY score DESC;

/*
 probe | sample | score 
-------+--------+-------
 101_1 | 101_2  |   103
 101_1 | 101_4  |    80
 101_1 | 101_7  |    49
 101_1 | 101_6  |    48
 101_1 | 101_5  |    41
(5 rows)
*/

-- faster: returns a single matching!
SELECT b.fp AS first_match
FROM casia a, casia b
WHERE a.fp = '001_L0_0'
  AND b.fp != a.fp
  AND bz_match(a.mdt, b.mdt) >= 40
LIMIT 1;

/*
 first_match 
-------------
 101_2
(1 row)
*/


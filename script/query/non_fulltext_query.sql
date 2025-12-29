EXPLAIN
-- EXPLAIN ANALYZE
SELECT
    id,
    title,
    body
FROM
    article_non_fulltexts
WHERE
    title LIKE '%MySQL%' OR title LIKE '%search%'
    OR body LIKE '%MySQL%' OR body LIKE '%search%'
ORDER BY
    id DESC;

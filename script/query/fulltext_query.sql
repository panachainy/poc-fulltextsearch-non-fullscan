EXPLAIN
-- EXPLAIN ANALYZE
SELECT
    id,
    title,
    MATCH(title, body) AGAINST ('MySQL search' IN NATURAL LANGUAGE MODE) AS relevance
FROM
    article_fulltexts
WHERE
    MATCH(title, body) AGAINST ('MySQL search' IN NATURAL LANGUAGE MODE)
ORDER BY
    relevance DESC;

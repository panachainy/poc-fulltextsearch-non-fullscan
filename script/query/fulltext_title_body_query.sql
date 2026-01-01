-- EXPLAIN
-- EXPLAIN ANALYZE
SELECT
    id,
    title,
    body,
    MATCH(title_body) AGAINST ('+mysql +Search' IN BOOLEAN MODE) AS relevance
FROM article_fulltexts
WHERE MATCH(title_body) AGAINST ('+mysql +Search' IN BOOLEAN MODE)
ORDER BY relevance DESC
LIMIT 20;

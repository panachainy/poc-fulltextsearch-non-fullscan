
-- ตัวอย่าง query full-text search
SELECT
    id,
    title,
    MATCH(title, body) AGAINST ('MySQL search' IN NATURAL LANGUAGE MODE) AS relevance
FROM
    articles
WHERE
    MATCH(title, body) AGAINST ('MySQL search' IN NATURAL LANGUAGE MODE)
ORDER BY
    relevance DESC;

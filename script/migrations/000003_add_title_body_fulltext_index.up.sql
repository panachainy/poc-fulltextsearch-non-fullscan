ALTER TABLE article_fulltexts
ADD COLUMN title_body TEXT
    GENERATED ALWAYS AS (CONCAT_WS(' ', title, body)) STORED,
ADD FULLTEXT INDEX ft_title_body (title_body);

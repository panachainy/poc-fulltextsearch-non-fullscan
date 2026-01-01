CREATE TABLE article_fulltexts (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- FULLTEXT KEY idx_fulltext_title_body (title, body)  -- full-text index
) ENGINE=InnoDB;

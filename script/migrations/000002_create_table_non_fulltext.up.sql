CREATE TABLE article_non_fulltexts (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_title_body (title(100), body(100))  -- regular index instead of full-text
) ENGINE=InnoDB;

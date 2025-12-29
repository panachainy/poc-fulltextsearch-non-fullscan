INSERT INTO article_non_fulltexts (title, body) VALUES
('Introduction to MySQL', 'MySQL is a popular open-source relational database management system that is widely used for web applications.'),
('Full-Text Search in MySQL', 'Full-text search lets you efficiently search text with MATCH AGAINST. This is much faster than LIKE queries for large text fields.'),
('Performance Tips', 'Indexes matter. Full-text indexes avoid table scans for text search and provide significant performance improvements.'),
('Database Optimization', 'Optimizing database queries requires understanding of indexes, query execution plans, and proper schema design.'),
('Understanding Joins', 'SQL joins allow you to combine rows from two or more tables based on related columns between them.'),
('MySQL Transactions', 'Transactions ensure data integrity by grouping multiple operations into a single atomic unit of work.'),
('Stored Procedures', 'Stored procedures are precompiled SQL code that can be saved and reused, improving performance and security.'),
('Database Normalization', 'Normalization is the process of organizing data to minimize redundancy and improve data integrity.'),
('Indexing Strategies', 'Choosing the right indexes is crucial for database performance. Consider cardinality, query patterns, and selectivity.'),
('MySQL Replication', 'Replication allows data from one MySQL database to be copied automatically to one or more databases.');

-- Generate 999,990 more records (total 1 million)
INSERT INTO article_non_fulltexts (title, body)
SELECT
    CONCAT('Article ', n, ': ',
        CASE (n % 20)
            WHEN 0 THEN 'Database Performance'
            WHEN 1 THEN 'Web Development'
            WHEN 2 THEN 'Cloud Computing'
            WHEN 3 THEN 'Data Analytics'
            WHEN 4 THEN 'Machine Learning'
            WHEN 5 THEN 'API Design'
            WHEN 6 THEN 'Security Best Practices'
            WHEN 7 THEN 'Microservices Architecture'
            WHEN 8 THEN 'DevOps Practices'
            WHEN 9 THEN 'Containerization'
            WHEN 10 THEN 'Kubernetes Guide'
            WHEN 11 THEN 'Python Programming'
            WHEN 12 THEN 'JavaScript Framework'
            WHEN 13 THEN 'React Development'
            WHEN 14 THEN 'Node.js Backend'
            WHEN 15 THEN 'Testing Strategies'
            WHEN 16 THEN 'CI/CD Pipeline'
            WHEN 17 THEN 'Monitoring Solutions'
            WHEN 18 THEN 'System Design'
            ELSE 'Software Engineering'
        END
    ) AS title,
    CONCAT(
        'This is article number ', n, '. ',
        'It contains information about various technical topics including database management, ',
        'full-text search capabilities, performance optimization, and best practices. ',
        'The content discusses how to efficiently handle large datasets and implement scalable solutions. ',
        CASE (n % 10)
            WHEN 0 THEN 'Performance is critical for modern applications. Optimization techniques include caching, indexing, and query tuning.'
            WHEN 1 THEN 'Security should be a top priority. Always validate input, use prepared statements, and implement proper authentication.'
            WHEN 2 THEN 'Scalability requires careful planning. Consider horizontal scaling, load balancing, and distributed systems.'
            WHEN 3 THEN 'Testing ensures code quality. Implement unit tests, integration tests, and end-to-end tests.'
            WHEN 4 THEN 'Documentation is essential. Write clear comments, maintain API documentation, and create user guides.'
            WHEN 5 THEN 'Code review improves quality. Collaborate with team members and follow coding standards.'
            WHEN 6 THEN 'Monitoring helps detect issues. Use logging, metrics, and alerting systems.'
            WHEN 7 THEN 'Automation saves time. Implement CI/CD pipelines and automated testing.'
            WHEN 8 THEN 'Clean code is maintainable. Follow SOLID principles and design patterns.'
            ELSE 'Continuous learning is important. Stay updated with new technologies and best practices.'
        END
    ) AS body
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + e.N * 10000 + f.N * 100000 AS n
    FROM
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) e,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) f
    WHERE a.N + b.N * 10 + c.N * 100 + d.N * 1000 + e.N * 10000 + f.N * 100000 BETWEEN 1 AND 999990
) numbers;

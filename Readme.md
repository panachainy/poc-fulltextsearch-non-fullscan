# POC: Full-Text Search vs Non-Full-Text Search Performance

This project demonstrates the performance difference between MySQL FULLTEXT search and traditional LIKE-based search on 1 million records.

## Project Structure

```
script/
├── migrations/          # Database migrations for setup
│   ├── 000001_create_table_fulltext.up.sql
│   ├── 000002_create_table_non_fulltext.up.sql
│   ├── 000003_seed_table_fulltext.up.sql
│   └── 000004_seed_table_non_fulltext.up.sql
└── query/              # Query examples for performance testing
    ├── fulltext_query.sql
    └── non_fulltext_query.sql
```

## Script Explanations

### script/migrations/

The migrations directory contains SQL files that set up the database schema and seed data for comparing FULLTEXT vs non-FULLTEXT search performance.

#### Migration Files

1. **000001_create_table_fulltext.up.sql**
   - Creates `article_fulltexts` table with a FULLTEXT index on `title` and `body` columns
   - Uses `FULLTEXT KEY idx_fulltext_title_body (title, body)` for optimized text searching

2. **000002_create_table_non_fulltext.up.sql**
   - Creates `article_non_fulltexts` table with a regular B-tree index on `title` and `body`
   - Uses `INDEX idx_title_body (title(100), body(100))` which only indexes the first 100 characters

3. **000003_seed_table_fulltext.up.sql**
   - Seeds the `article_fulltexts` table with 1 million records
   - Contains 10 initial articles with relevant content
   - Generates 999,990 additional articles with various topics

4. **000004_seed_table_non_fulltext.up.sql**
   - Seeds the `article_non_fulltexts` table with identical 1 million records
   - Same data structure as the fulltext table for fair comparison

### script/query/

The query directory contains example queries to demonstrate and test the performance difference between FULLTEXT and traditional LIKE-based searching.

#### Query Files

1. **fulltext_query.sql** (FULLTEXT Search)
   - Uses `MATCH(title, body) AGAINST ('MySQL search' IN NATURAL LANGUAGE MODE)`
   - Leverages the FULLTEXT index for efficient text searching
   - Returns results with relevance scoring
   - Uses `EXPLAIN` to show the execution plan

2. **non_fulltext_query.sql** (Traditional LIKE Search)
   - Uses `LIKE '%MySQL%' OR title LIKE '%search%' OR body LIKE '%MySQL%' OR body LIKE '%search%'`
   - Cannot effectively use the regular B-tree index due to leading wildcard
   - Requires full table scan for matching patterns
   - Uses `EXPLAIN` to show the execution plan

## Key Differences

| Feature               | FULLTEXT Search                   | Non-FULLTEXT (LIKE) Search                |
| --------------------- | --------------------------------- | ----------------------------------------- |
| **Index Type**        | FULLTEXT index                    | B-tree index (limited to first 100 chars) |
| **Search Method**     | MATCH...AGAINST                   | LIKE with wildcards                       |
| **Index Utilization** | ✅ Uses FULLTEXT index efficiently | ❌ Cannot use index with leading wildcards |
| **Performance**       | Fast (optimized for text search)  | Slow (requires full table scan)           |
| **Relevance Scoring** | ✅ Built-in relevance ranking      | ❌ No relevance scoring                    |
| **Word Boundaries**   | ✅ Understands word boundaries     | ❌ Pattern matching only                   |

## Setup

Run migrations to create tables and seed data:

```bash
make mu
```

## Performance Test Results

### FULLTEXT Search (fulltext_query.sql)

#### EXPLAIN FULLTEXT

| id  | select_type | table             | partitions | type     | possible_keys           | key                     | key_len | ref   | rows | filtered | Extra                         |
| --- | ----------- | ----------------- | ---------- | -------- | ----------------------- | ----------------------- | ------- | ----- | ---- | -------- | ----------------------------- |
| 1   | SIMPLE      | article_fulltexts |            | fulltext | idx_fulltext_title_body | idx_fulltext_title_body | 0       | const | 1    | 100.0    | Using where; Ft_hints: sorted |

#### EXPLAIN ANALYZE FULLTEXT

-> Filter: (match article_fulltexts.title,article_fulltexts.body against ('MySQL search'))  (cost=1.05 rows=1) (actual time=403..5226 rows=999995 loops=1)
    -> Full-text index search on article_fulltexts using idx_fulltext_title_body (title='MySQL search')  (cost=1.05 rows=1) (actual time=403..5121 rows=999995 loops=1)

**Key Metrics:**

- Execution Time:
- Rows Examined:
- Type:
- Extra:

### Non-FULLTEXT Search (non_fulltext_query.sql)

#### EXPLAIN Non-FULLTEXT

| id  | select_type | table                 | partitions | type  | possible_keys | key     | key_len | ref | rows   | filtered | Extra                            |
| --- | ----------- | --------------------- | ---------- | ----- | ------------- | ------- | ------- | --- | ------ | -------- | -------------------------------- |
| 1   | SIMPLE      | article_non_fulltexts |            | index |               | PRIMARY | 4       |     | 946441 | 37.57    | Using where; Backward index scan |

#### EXPLAIN ANALYZE Non-FULLTEXT

-> Filter: ((article_non_fulltexts.title like '%MySQL%') or (article_non_fulltexts.title like '%search%') or (article_non_fulltexts.body like '%MySQL%') or (article_non_fulltexts.body like '%search%'))  (cost=123558 rows=355553) (actual time=1.5..5326 rows=999995 loops=1)
    -> Index scan on article_non_fulltexts using PRIMARY (reverse)  (cost=123558 rows=946441) (actual time=1.27..1853 rows=1e+6 loops=1)

**Key Metrics:**

- Execution Time:
- Rows Examined:
- Type:
- Extra:

## Conclusion

Based on the performance test results with 1 million records, both search approaches showed comparable total execution times (~5.2 seconds), but with fundamentally different characteristics:

### Key Findings

1. **Index Utilization**
   - ✅ **FULLTEXT**: Successfully used `idx_fulltext_title_body` index (type: fulltext)
   - ⚠️ **Non-FULLTEXT**: Performed index scan on PRIMARY key but still examined all rows (type: index)

2. **Query Execution Characteristics**
   - **FULLTEXT Search**:
     - Total time: ~5.2 seconds (403ms startup + 4.8s data retrieval)
     - Rows examined: 999,995 matching rows
     - Method: Specialized fulltext index search with relevance ranking

   - **Non-FULLTEXT Search**:
     - Total time: ~5.3 seconds (1.5ms filter + 1.8s index scan + 3.5s filtering)
     - Rows examined: 1,000,000 (full table scan)
     - Method: Index scan with post-filter pattern matching

3. **Performance Analysis**
   - In this specific test case, execution times were similar because **999,995 out of 1 million records matched** the search criteria
   - The high match ratio (99.9995%) meant both approaches processed nearly all rows
   - FULLTEXT's advantage is diminished when result sets are extremely large

4. **Expected Performance in Real-World Scenarios**
   - With more selective searches (< 10% match rate), FULLTEXT would show significant advantages
   - FULLTEXT provides relevance scoring, enabling sorted results by relevance
   - LIKE-based searches cannot utilize indexes with leading wildcards (`%term%`)
   - FULLTEXT understands word boundaries and linguistic features

### Recommendations

- **Use FULLTEXT when**: Searching text content with moderate to low result sets, need relevance ranking, or require linguistic features
- **Avoid LIKE with wildcards when**: Dealing with large datasets or when performance is critical
- **Consider**: Adjusting test data to have more selective search criteria (5-10% match rate) for more realistic performance comparison

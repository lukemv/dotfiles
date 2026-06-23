-- SQL playground — treesitter highlighting only.
CREATE TABLE users (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age  INTEGER
);

INSERT INTO users (name, age) VALUES ('Luke', 30);

SELECT name, age
FROM users
WHERE age >= 18
ORDER BY name;

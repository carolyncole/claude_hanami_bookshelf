CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `books`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `author` varchar(255),
  `created_at` timestamp NOT NULL,
  `title` varchar(255),
  `updated_at` timestamp NOT NULL
);
INSERT INTO schema_migrations (filename) VALUES
('20261002164845_create_books.rb');

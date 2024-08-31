CREATE TABLE `routes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `reward` INT NOT NULL
);
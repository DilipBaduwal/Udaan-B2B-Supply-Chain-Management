-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema dbms_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dbms_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbms_project` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `dbms_project` ;

-- -----------------------------------------------------
-- Table `dbms_project`.`customer_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`customer_data` (
  `customer_id` VARCHAR(10) NOT NULL,
  `customer_name` VARCHAR(50) NULL DEFAULT NULL,
  `contact_num` BIGINT NULL DEFAULT NULL,
  `pincode` INT NULL DEFAULT NULL,
  `address` VARCHAR(100) NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `state` CHAR(20) NULL DEFAULT NULL,
  `status` ENUM('active', 'dormant') NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`driver_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`driver_detail` (
  `driver_id` INT NOT NULL,
  `driver_name` VARCHAR(50) NULL DEFAULT NULL,
  `allocated_warehouse_id` VARCHAR(5) NULL DEFAULT NULL,
  `age` INT NULL DEFAULT NULL,
  `number` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`driver_id`),
  INDEX `allocated_warehouse_id` (`allocated_warehouse_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`product` (
  `product_pk` INT NOT NULL AUTO_INCREMENT,
  `product_id` VARCHAR(20) NULL DEFAULT NULL,
  `brand_name` VARCHAR(50) NULL DEFAULT NULL,
  `product_name` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`product_pk`),
  UNIQUE INDEX `product_unique` (`product_id` ASC, `brand_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`placed_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`placed_orders` (
  `order_id` VARCHAR(10) NOT NULL,
  `customer_id` VARCHAR(10) NULL DEFAULT NULL,
  `order_date` DATETIME NULL DEFAULT NULL,
  `product_pk` INT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  `qty` INT NULL DEFAULT NULL,
  `t_price` DECIMAL(10,2) NULL DEFAULT NULL,
  `pincode` INT NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `state` CHAR(20) NULL DEFAULT NULL,
  `placed_address` VARCHAR(100) NULL DEFAULT NULL,
  `order_status` ENUM('delivered', 'intransit', 'undelivered') NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `product_pk` (`product_pk` ASC) VISIBLE,
  CONSTRAINT `placed_orders_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `dbms_project`.`customer_data` (`customer_id`),
  CONSTRAINT `placed_orders_ibfk_3`
    FOREIGN KEY (`product_pk`)
    REFERENCES `dbms_project`.`product` (`product_pk`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`sku`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`sku` (
  `sku_id` VARCHAR(10) NOT NULL,
  `product_pk` INT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  `pack_size` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`sku_id`),
  INDEX `product_pk` (`product_pk` ASC) VISIBLE,
  CONSTRAINT `sku_ibfk_1`
    FOREIGN KEY (`product_pk`)
    REFERENCES `dbms_project`.`product` (`product_pk`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`warehouse` (
  `warehouse_id` VARCHAR(5) NOT NULL,
  `product_pk` INT NULL DEFAULT NULL,
  `inbound_price` DECIMAL(10,2) NULL DEFAULT NULL,
  `pincode` INT NULL DEFAULT NULL,
  `sku_id` VARCHAR(10) NOT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `state` CHAR(20) NULL DEFAULT NULL,
  `qty` INT NULL DEFAULT NULL,
  `w_inprice` DECIMAL(12,2) GENERATED ALWAYS AS ((`inbound_price` * `qty`)) STORED,
  PRIMARY KEY (`warehouse_id`, `sku_id`),
  INDEX `product_pk` (`product_pk` ASC) VISIBLE,
  INDEX `sku_id` (`sku_id` ASC) VISIBLE,
  CONSTRAINT `warehouse_ibfk_1`
    FOREIGN KEY (`product_pk`)
    REFERENCES `dbms_project`.`product` (`product_pk`),
  CONSTRAINT `warehouse_ibfk_2`
    FOREIGN KEY (`sku_id`)
    REFERENCES `dbms_project`.`sku` (`sku_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`logistic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`logistic` (
  `shipping_id` VARCHAR(10) NOT NULL,
  `shipping_order` VARCHAR(10) NULL DEFAULT NULL,
  `warehouse_id` VARCHAR(5) NULL DEFAULT NULL,
  `driver_id` INT NULL DEFAULT NULL,
  `delivery_date` DATETIME NULL DEFAULT NULL,
  `delivery_status` ENUM('delivered', 'in transit', 'yet to ship', 'RTO') NULL DEFAULT NULL,
  PRIMARY KEY (`shipping_id`),
  INDEX `driver_id` (`driver_id` ASC) VISIBLE,
  INDEX `logistic_ibfk_2` (`warehouse_id` ASC) VISIBLE,
  INDEX `logistic_ibfk_1` (`shipping_order` ASC) VISIBLE,
  CONSTRAINT `logistic_ibfk_1`
    FOREIGN KEY (`shipping_order`)
    REFERENCES `dbms_project`.`placed_orders` (`order_id`),
  CONSTRAINT `logistic_ibfk_2`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `dbms_project`.`warehouse` (`warehouse_id`),
  CONSTRAINT `logistic_ibfk_3`
    FOREIGN KEY (`driver_id`)
    REFERENCES `dbms_project`.`driver_detail` (`driver_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`supplier` (
  `supplier_id` VARCHAR(10) NOT NULL,
  `product_pk` INT NULL DEFAULT NULL,
  `selling_price` DECIMAL(10,2) NULL DEFAULT NULL,
  `shipped_warehouse_id` VARCHAR(5) NULL DEFAULT NULL,
  `product_mrp` DECIMAL(10,2) NULL DEFAULT NULL,
  `sku_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`supplier_id`, `sku_id`),
  INDEX `product_pk` (`product_pk` ASC) VISIBLE,
  INDEX `sku_id` (`sku_id` ASC) VISIBLE,
  INDEX `supplier_ibfk_2` (`shipped_warehouse_id` ASC) VISIBLE,
  CONSTRAINT `supplier_ibfk_1`
    FOREIGN KEY (`product_pk`)
    REFERENCES `dbms_project`.`product` (`product_pk`),
  CONSTRAINT `supplier_ibfk_2`
    FOREIGN KEY (`shipped_warehouse_id`)
    REFERENCES `dbms_project`.`warehouse` (`warehouse_id`),
  CONSTRAINT `supplier_ibfk_3`
    FOREIGN KEY (`sku_id`)
    REFERENCES `dbms_project`.`sku` (`sku_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`supplier_has_warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`supplier_has_warehouse` (
  `supplier_supplier_id` VARCHAR(10) NOT NULL,
  `supplier_sku_id` VARCHAR(10) NOT NULL,
  `warehouse_warehouse_id` VARCHAR(5) NOT NULL,
  `warehouse_sku_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`supplier_supplier_id`, `supplier_sku_id`, `warehouse_warehouse_id`, `warehouse_sku_id`),
  INDEX `fk_supplier_has_warehouse_warehouse1_idx` (`warehouse_warehouse_id` ASC, `warehouse_sku_id` ASC) VISIBLE,
  INDEX `fk_supplier_has_warehouse_supplier1_idx` (`supplier_supplier_id` ASC, `supplier_sku_id` ASC) VISIBLE,
  CONSTRAINT `fk_supplier_has_warehouse_supplier1`
    FOREIGN KEY (`supplier_supplier_id` , `supplier_sku_id`)
    REFERENCES `dbms_project`.`supplier` (`supplier_id` , `sku_id`),
  CONSTRAINT `fk_supplier_has_warehouse_warehouse1`
    FOREIGN KEY (`warehouse_warehouse_id` , `warehouse_sku_id`)
    REFERENCES `dbms_project`.`warehouse` (`warehouse_id` , `sku_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbms_project`.`warehouse_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbms_project`.`warehouse_has_product` (
  `warehouse_warehouse_id` VARCHAR(5) NOT NULL,
  `warehouse_sku_id` VARCHAR(10) NOT NULL,
  `product_product_pk` INT NOT NULL,
  PRIMARY KEY (`warehouse_warehouse_id`, `warehouse_sku_id`, `product_product_pk`),
  INDEX `fk_warehouse_has_product_product1_idx` (`product_product_pk` ASC) VISIBLE,
  INDEX `fk_warehouse_has_product_warehouse1_idx` (`warehouse_warehouse_id` ASC, `warehouse_sku_id` ASC) VISIBLE,
  CONSTRAINT `fk_warehouse_has_product_product1`
    FOREIGN KEY (`product_product_pk`)
    REFERENCES `dbms_project`.`product` (`product_pk`),
  CONSTRAINT `fk_warehouse_has_product_warehouse1`
    FOREIGN KEY (`warehouse_warehouse_id` , `warehouse_sku_id`)
    REFERENCES `dbms_project`.`warehouse` (`warehouse_id` , `sku_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

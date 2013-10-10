SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

grant all privileges on jognavi.* to jognavi@localhost identified by 'atamishi';


CREATE SCHEMA IF NOT EXISTS `jognavi`;
USE `jognavi` ;

-- -----------------------------------------------------
-- Table `mydb`.`Tweet`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jognavi`.`Route` (
      id int not null auto_increment,
      name text,
      start_address text,
      type int,
      route_color text,
      description text,
      distance decimal(5,3) not null,
      g LINESTRING NOT NULL,
      create_user text,
      create_at datetime,
      primary key (id),
      spatial key (g)
      )  ENGINE=MYISAM;
 
 -- -----------------------------------------------------
-- Table `jognavi`.`User`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jognavi`.`User` 
(
      id int not null auto_increment,
      site varchar (20),
      user_id  varchar(128),
      screen_name text,
      create_at datetime,
      primary key (id),
      unique (site,user_id)
);

CREATE  TABLE IF NOT EXISTS `jognavi`.`Equipment` (
      id int not null auto_increment,
      user_id int,
      bought_at datetime,
      polish_at datetime,
      name text,
      img text,
      url text,
      store_name text,
      store_url text,
      price   int,
      create_user text,
      create_at datetime,
      primary key (id),
      index(user_id, bought_at)
      );

CREATE  TABLE IF NOT EXISTS `jognavi`.`Record` (
      id int not null auto_increment,
      user_id int,
      run_at datetime,
      route_id int,
      run_time time,
      create_user text,
      create_at datetime,
      primary key (id),
      index(user_id, route_id, run_at),
      index(id, run_time)
      );

CREATE  TABLE IF NOT EXISTS `jognavi`.`UserRoute` (
      user_id int not null,
      route_id int not null,
      create_user text,
      create_at datetime,
      primary key (user_id, route_id)
      );


CREATE  TABLE IF NOT EXISTS `jognavi`.`RecordEquipment` (
      record_id int not null,
      equipment_id int not null,
      create_user text,
      create_at datetime,
      primary key (record_id, equipment_id)
      );


insert into  `jognavi`.`Record` 
values
(1,3,current_date,5,'00:01:00','test',current_date),
(2,3,current_date,5,'00:01:20','test',current_date),
(3,3,current_date,5,'00:01:30','test',current_date),
(4,4,current_date,5,'00:01:40','test',current_date),
(5,4,current_date,5,'00:01:50','test',current_date),
(6,3,current_date,6,'00:01:00','test',current_date),
(7,3,current_date,6,'00:01:20','test',current_date),
(8,4,current_date,6,'00:01:30','test',current_date),
(9,4,current_date,6,'00:01:40','test',current_date),
(10,4,current_date,6,'00:01:50','test',current_date),
(11,4,current_date,6,'00:01:53','test',current_date);

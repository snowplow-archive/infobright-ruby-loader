drop database if exists irl_tests;
create database irl_tests;
use irl_tests;
create table b (id int, description varchar(255)) engine=brighthouse;
create table c (id int, description varchar(255)) engine=brighthouse;
create table d (id int, description varchar(255)) engine=brighthouse;
create table e (id int, description varchar(255)) engine=brighthouse;
create table f (id int, description varchar(255)) engine=brighthouse;
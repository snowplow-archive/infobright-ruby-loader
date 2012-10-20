drop database if exists irl_test;
create database irl_test;
use irl_test;
create table a (id int, description varchar(255)) engine=brighthouse;
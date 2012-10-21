drop database if exists irl_tests;
create database irl_tests;
use irl_tests;
create table a (id int, description varchar(255)) engine=brighthouse;
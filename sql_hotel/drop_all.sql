-- card
drop trigger card_expire_date;
drop trigger card_id;
drop table card cascade constraints;
drop package generated_data;
drop package debuging_mode;
drop package cards_methods;
drop sequence seq_card_id;
-- end card

-- category_room
drop trigger add_room_to_category;
drop trigger category_id;
drop trigger update_room_reservation;
drop table category_room cascade constraints;
drop sequence seq_category_id;
-- end category_room

-- customer
drop trigger customer_id;
drop table customer cascade constraints;
drop sequence seq_customer_id;
-- end customer

-- customer_service
drop trigger customer_service_id;
drop table customer_service cascade constraints;
drop sequence seq_customer_service_id;
-- end customer_service

-- deposit_box
drop trigger deposit_box_id;
drop table deposit_box cascade constraints;
drop sequence seq_deposit_box_id;
-- end deposit_box

-- registry
drop trigger registry_id;
drop table registry cascade constraints;
drop sequence seq_registry_id;
-- end registry

-- reservation
drop trigger add_to_registry;
drop trigger reservation_id;
drop table reservation cascade constraints;
drop sequence seq_reservation_id;
-- end reservation

-- room
drop trigger room_id;
drop table room cascade constraints;
drop package room_methods;
drop sequence seq_room_id;
-- end room
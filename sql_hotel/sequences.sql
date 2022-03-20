-- generate number id for card 
create sequence seq_card_id
  minvalue 1000
  start with 1000
  increment by 1
  nocache;
  
create sequence seq_customer_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_category_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_customer_service_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_deposit_box_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_registry_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_reservation_id
  minvalue 1
  start with 1
  increment by 1
  nocache;
  
create sequence seq_room_id 
  minvalue 0
  start with 0
  increment by 1
  nocache;
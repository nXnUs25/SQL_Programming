alter table card add
  constraint pk_id_card primary key (id_card); 

alter table category_room add
  constraint pk_id_category primary key (id_category);
  
alter table customer_service add
  constraint pk_id_service primary key (id_service);
  
alter table deposit_box add
  constraint pk_id_box primary key (id_box);
  
alter table registry add
  constraint pk_id_registry primary key (id_registry);
  
alter table customer add
  constraint pk_c_id_customer primary key (id_customer);  
  
alter table reservation add
  constraint pk_id_reservation primary key (id_reservation);
  
alter table room add
  constraint pk_id_room primary key (id_room);
  
  -- #####################################################
  
alter table customer add
  constraint fk_c_id_card foreign key (id_card) references card(id_card) on delete cascade;
  
  
alter table registry add
  constraint fk_r_id_room foreign key (id_room) references room(id_room) on delete cascade;
  
alter table registry add
  constraint fk_r_id_customer foreign key (id_customer) references customer(id_customer) on delete cascade;
  
alter table registry add 
  constraint fk_r_id_services foreign key (id_services) references customer_service(id_service);
  
alter table registry add
  constraint fk_r_id_deposit foreign key (id_deposit) references deposit_box(id_box);
  
  
alter table reservation add
  constraint fk_rv_id_room foreign key (id_room) references room(id_room) on delete cascade;
  
alter table category_room add
  constraint fk_cr_id_room foreign key (id_category) references category_room(id_category) on delete cascade;
  
alter table reservation add
  constraint fk_rv_id_customer foreign key (id_customer) references customer(id_customer) on delete cascade;

-- #######################################################

alter table customer add
  constraint check_phone check (
      substr(phone, 1, 1) BETWEEN '0' AND '9' AND
			substr(phone, 2, 1) BETWEEN '0' AND '9' AND
			substr(phone, 3, 1) BETWEEN '0' AND '9' AND
			substr(phone, 4, 1) BETWEEN '0' AND '9' AND
			substr(phone, 5, 1) BETWEEN '0' AND '9' AND
			substr(phone, 6, 1) BETWEEN '0' AND '9' AND
			substr(phone, 7, 1) BETWEEN '0' AND '9' AND
			substr(phone, 8, 1) BETWEEN '0' AND '9' AND
			substr(phone, 9, 1) BETWEEN '0' AND '9'
      )
;
-- ############### idnexes
create index inx_customer on customer(lname);
create index inx_registry on registry(id_customer);
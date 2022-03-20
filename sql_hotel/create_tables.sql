--drop table card;
CREATE TABLE card
  (
    id_card     NUMBER NOT NULL,
    period      NUMBER DEFAULT 3,
    count_visit NUMBER DEFAULT 0,
    holder_name NVARCHAR2(51) NOT NULL,
    discount FLOAT(3) DEFAULT 0,
    expired_date DATE
  );
CREATE TABLE customer
  (
    id_customer NUMBER NOT NULL,
    fname NVARCHAR2(20) NOT NULL,
    lname NVARCHAR2(30) NOT NULL,
    phone   CHAR(9),
    id_card NUMBER
  );
CREATE TABLE registry
  (
    id_registry NUMBER NOT NULL,
    id_room     NUMBER,
    id_customer NUMBER NOT NULL,
    from_date DATE,
    to_date DATE,
    bill        NUMBER(19,4),
    id_services NUMBER,
    id_deposit  NUMBER
  );
CREATE TABLE deposit_box
  (
    id_box NUMBER NOT NULL,
    desc_box nvarchar2(30),
    price NUMBER(19,4)
  );
CREATE TABLE customer_service
  (
    id_service NUMBER NOT NULL,
    price FLOAT(2),
    service_name NVARCHAR2(20)
  );
CREATE TABLE room
  (
    id_room       NUMBER NOT NULL,
    beds          NUMBER DEFAULT 1,
    taken         NUMBER DEFAULT 0,
    price_per_day NUMBER(19,4) DEFAULT 30,
    id_category   NUMBER
  );
CREATE TABLE category_room
  (
    id_category NUMBER NOT NULL,
    cat_name NVARCHAR2(30) NOT NULL,
    description NVARCHAR2(255)
  );
-- junction table for customer and room
CREATE TABLE reservation
  (
    id_reservation NUMBER NOT NULL,
    start_date DATE,
    many_days   NUMBER DEFAULT 1,
    id_room     NUMBER NOT NULL,
    id_customer NUMBER NOT NULL
  );
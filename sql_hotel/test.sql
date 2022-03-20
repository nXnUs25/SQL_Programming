-- declaration of the procedures used for testing
CREATE OR REPLACE
PROCEDURE test_insert_for_customers(
    fname$ IN NVARCHAR2,
    lname$ IN NVARCHAR2,
    phone$ IN NVARCHAR2)
IS
  customer_insert EXCEPTION;
BEGIN
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG TEST] test_insert_for_customers fname$: ' || fname$ || ', lname$: ' || lname$ || ', phone$: ' || phone$);
  END IF;
  IF fname$ IS NULL OR lname$ IS NULL OR phone$ IS NULL OR LENGTH(phone$) != 9 THEN
    raise customer_insert;
  END IF;
  INSERT INTO customer
    (fname, lname, phone
    ) VALUES
    (fname$, lname$, phone$
    );
EXCEPTION
WHEN customer_insert THEN
  DBMS_OUTPUT.put_line('[DEBUG TEST] test_insert_for_customers insert_exception occur: ' || '<' || phone$ || '>');
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line('[DEBUG TEST] test_insert_for_customers other exception occur');
END test_insert_for_customers;
/
-- anonymous block for testing package generated_data
DECLARE
  result_add_months DATE;
  period INTEGER;
BEGIN
  period := 4;
  debuging_mode.set_debug_mode(true);
  result_add_months := add_months(CURRENT_DATE, period);
  DBMS_OUTPUT.put_line('[DEBUG TEST] ' || result_add_months);
  result_add_months := generated_data.generate_expire_date(period);
  DBMS_OUTPUT.put_line('[DEBUG TEST] ' || result_add_months);
END;
/
INSERT INTO card
  (holder_name
  ) VALUES
  ('test test'
  );
SELECT * FROM card;
DELETE FROM card WHERE holder_name = 'test test';
SELECT * FROM card;
-- test for adding fname lname phone to customer db
-- id_customer will generate via trigger customer_id
-- debug logs can be read from dbms output in sql developer
BEGIN
  test_insert_for_customers('test', 'test', '1234567891');
  test_insert_for_customers('test', 'test', '123456789');
  test_insert_for_customers('test', 'test2', '123456789');
  test_insert_for_customers('test', 'test3', '12345678a');
  test_insert_for_customers('test', 'test3', NULL);
END;
/
SELECT * FROM customer;
DELETE FROM customer WHERE fname = 'test';
-- testing the cards_method
SELECT 'get_card_for_user ',
  '#########################'
FROM dual;
BEGIN
  cards_methods.get_card_for_user('adam', 'chmiel', 6);
  cards_methods.get_card_for_user('adam', 'ch', 2);
  cards_methods.get_card_for_user('marcin', 'brzeszczykiewicz', 12);
END;
/
SELECT * FROM card;
SELECT * FROM customer;
BEGIN
  cards_methods.update_visit_in_card('adam', 'chmiel');
  cards_methods.update_visit_in_card('adam', 'chmiel');
END;
/
SELECT * FROM card;
SELECT cards_methods.card_id_for_customer('adam', 'chmiel') FROM dual;
BEGIN
  room_methods.make_reservation('adam', 'chmiel', 2, CURRENT_DATE + interval '7' DAY, 14);
  room_methods.make_reservation('adam', 'chmiel', 3, CURRENT_DATE, 14);
END;
/
SELECT * FROM reservation;
SELECT * FROM room;
BEGIN
  room_methods.check_date(CURRENT_DATE + interval '71' DAY,  CURRENT_DATE + interval '7' DAY);
  room_methods.check_date(CURRENT_DATE + interval '7' DAY, CURRENT_DATE + interval '17' DAY);
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG TEST] others exception occur msg <' || SQLERRM || '>' );
END;
/
BEGIN
  room_methods.check_taken_room(2);
  room_methods.check_taken_room(3);
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG TEST] others exception occur msg <' || SQLERRM || '>' );
END;
/

SELECT * FROM reservation;
BEGIN
  room_methods.cancel_reservation('adam', 'chmiel', CURRENT_DATE + interval '7' DAY);
  room_methods.release_room('adam', 'chmiel', 3);
END;
/
insert into room(beds, taken, price_per_day) values(5, 0, 250);
insert into category_room(cat_name, description) values('five', 'Room is really big');
select * from room;
SELECT * FROM reservation;
insert into room(beds, taken, price_per_day) values(6, 0, 250);
select * from room;
select * from registry;
begin
room_methods.add_deposit('augustyn', 'chmiel', current_date, 14, 2);
room_methods.add_deposit('adam', 'chmiel', current_date, 14, 4);
end;
/
select * from registry;

begin
room_methods.add_service('augustyn', 'chmiel',2);
room_methods.add_service('adam', 'chmiel',4);
end;
/
select * from registry;

-- clean after test, reset all data
DROP PROCEDURE test_insert_for_customers;
@ drop_all;
@ sequences;
@ create_tables;
@ alters;
@ my_packages;
@ my_triggers;
@ inserting_data;
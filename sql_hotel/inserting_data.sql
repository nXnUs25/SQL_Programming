-- insert data to customer
INSERT
INTO customer
  (
    fname,
    lname,
    phone
  )
  VALUES
  (
    'adam',
    'chmiel',
    '123456789'
  );
INSERT
INTO customer
  (
    fname,
    lname,
    phone
  )
  VALUES
  (
    'augustyn',
    'chmiel',
    '123456710'
  );
INSERT
INTO customer
  (
    fname,
    lname,
    phone
  )
  VALUES
  (
    'marcin',
    'brzeszczykiewicz',
    '123422789'
  );
INSERT
INTO customer
  (
    fname,
    lname,
    phone
  )
  VALUES
  (
    'david',
    'trzmielewski',
    '008542255'
  );
-- this anonymus block will print table customer if debuging mode is true
DECLARE
  CURSOR cur
  IS
    SELECT * FROM customer;
BEGIN
  IF debuging_mode.debug_mode THEN
    FOR rec IN cur
    LOOP
      DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || rec.id_customer || ', ' || rec.fname || ', ' || rec.lname || ', ' || rec.phone || ', ' || rec.id_card || '>');
    END LOOP;
  END IF;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, no data found exception');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, other exception');
END;
/
-- insert data to customer _service
INSERT
INTO customer_service
  (
    price,
    service_name
  )
  VALUES
  (
    20.20,
    'extra cleaning'
  );
INSERT INTO customer_service
  (price, service_name
  ) VALUES
  (25.60, 'laundry'
  );
INSERT
INTO customer_service
  (
    price,
    service_name
  )
  VALUES
  (
    100,
    'exotic massage'
  );
INSERT INTO customer_service
  (price, service_name
  ) VALUES
  (50, 'massage'
  );
-- -- this anonymus block will print table customer_service if debuging mode is true
DECLARE
  CURSOR cur
  IS
    SELECT * FROM customer_service;
BEGIN
  IF debuging_mode.debug_mode THEN
    FOR rec IN cur
    LOOP
      DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || rec.id_service || ', ' || rec.price || ', ' || rec.service_name || '>');
    END LOOP;
  END IF;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, no data found exception');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, other exception');
END;
/
-- insert data to room table
-- taken 0 mean that room is empty
-- empty room will allow add deposit and service to registry
INSERT
INTO room
  (
    beds,
    taken,
    price_per_day
  )
  VALUES
  (
    0,
    0,
    0
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (1, 0, 30
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (3, 0, 100
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (1, 0, 30
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (4, 0, 150
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (1, 0, 30
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (2, 0, 55
  );
INSERT INTO room
  (beds, taken, price_per_day
  ) VALUES
  (4, 0, 150
  );
-- this anonymus block will print table room if debuging mode is true
DECLARE
  CURSOR cur
  IS
    SELECT * FROM room;
BEGIN
  IF debuging_mode.debug_mode THEN
    FOR rec IN cur
    LOOP
      DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || rec.id_room || ', ' || rec.beds || ', ' || rec.taken || ', ' || rec.price_per_day || ', ' || rec.id_category || '>');
    END LOOP;
  END IF;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, no data found exception');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, other exception');
END;
/
-- insering data to category_room
INSERT
INTO category_room
  (
    cat_name,
    description
  )
  VALUES
  (
    'one bed',
    'Room with standard equipment, bathroom shared'
  );
INSERT
INTO category_room
  (
    cat_name,
    description
  )
  VALUES
  (
    'two beds',
    'Room with standard equipment plus a bathroom in room'
  );
INSERT
INTO category_room
  (
    cat_name,
    description
  )
  VALUES
  (
    'three beds',
    'Room with a high standard, plus a Jacuzzi'
  );
INSERT
INTO category_room
  (
    cat_name,
    description
  )
  VALUES
  (
    'four beds',
    'Room of the highest standard all included'
  );
-- this anonymus block will print table category_room if debuging mode is true
DECLARE
  CURSOR cur
  IS
    SELECT * FROM category_room;
BEGIN
  IF debuging_mode.debug_mode THEN
    FOR rec IN cur
    LOOP
      DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || rec.id_category || ', ' || rec.cat_name || ', ' || rec.description || '>');
    END LOOP;
  END IF;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, no data found exception');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, other exception');
END;
/
-- insert data to deposit box
INSERT
INTO deposit_box
  (
    desc_box,
    price
  )
  VALUES
  (
    'small cargo',
    10
  );
INSERT INTO deposit_box
  (desc_box, price
  ) VALUES
  ('average load', 20
  );
INSERT INTO deposit_box
  (desc_box, price
  ) VALUES
  ('big cargo', 30
  );
INSERT INTO deposit_box
  (desc_box, price
  ) VALUES
  ('valuable cargo', 100
  );
-- this anonymus block will print table category_room if debuging mode is true
DECLARE
  CURSOR cur
  IS
    SELECT * FROM deposit_box;
BEGIN
  IF debuging_mode.debug_mode THEN
    FOR rec IN cur
    LOOP
      DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || rec.id_box || ', ' || rec.desc_box || ', ' || rec.price || '>');
    END LOOP;
  END IF;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, no data found exception');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] anonymus block, other exception');
END;
/
-- inserting data via procedures and triggers
BEGIN
  cards_methods.get_card_for_user('adam', 'chmiel', 6);
  cards_methods.get_card_for_user('augustyn', 'chmiel', 2);
  cards_methods.get_card_for_user('marcin', 'brzeszczykiewicz', 12);
  cards_methods.get_card_for_user('david', 'trzmielewski', 12);
  cards_methods.update_visit_in_card('adam', 'chmiel');
  cards_methods.update_visit_in_card('adam', 'chmiel');
  room_methods.make_reservation('adam', 'chmiel', 2, CURRENT_DATE + interval '7' DAY, 14);
  room_methods.make_reservation('adam', 'chmiel', 3, CURRENT_DATE, 14);
  room_methods.add_deposit('augustyn', 'chmiel', CURRENT_DATE, 14, 2);
  room_methods.add_deposit('adam', 'chmiel', CURRENT_DATE, 14, 4);
  room_methods.add_service('augustyn', 'chmiel',2);
  room_methods.add_service('adam', 'chmiel',4);
END;
/
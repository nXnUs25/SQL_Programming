/*
this package will be used to debuging all operation
to enable debuging we have to call method set_debug_mode
with the parameter true
the procedure is setup the var debug_mode to true
*/
CREATE OR REPLACE
PACKAGE debuging_mode
AS
  debug_mode BOOLEAN := false;
PROCEDURE set_debug_mode(
    this_debug_mode IN BOOLEAN);
END debuging_mode;
/
CREATE OR REPLACE
PACKAGE body debuging_mode
AS
PROCEDURE set_debug_mode(
    this_debug_mode IN BOOLEAN)
AS
  found_null EXCEPTION;
BEGIN
  IF this_debug_mode IS NULL THEN
    raise found_null;
  END IF;
  debug_mode := this_debug_mode;
EXCEPTION
WHEN found_null THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] Proc set_debug_mode, exception found null can take [true | false]');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] Proc set_debug_mode, exception');
END set_debug_mode;
END debuging_mode;
/
-- ##########################################################################
-- ############################### generated data ###########################################
-- ##########################################################################
CREATE OR REPLACE
PACKAGE GENERATED_DATA
AS
FUNCTION generate_expire_date(
    period_in_months IN INTEGER)
  RETURN DATE;
END GENERATED_DATA;
/
CREATE OR REPLACE
PACKAGE body GENERATED_DATA
AS
FUNCTION generate_expire_date(
    period_in_months IN INTEGER)
  RETURN DATE
IS
  period INTEGER;
  today DATE;
  expire_date DATE;
BEGIN
  today := CURRENT_DATE;
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.PUT_LINE('[DEBUG] Func generate_expire_date, current date: ' || TO_CHAR(today, 'DD-MON-YYYY'));
  END IF;
  IF period_in_months < 3 THEN
    period           := 3;
  ELSE
    period := period_in_months;
  END IF;
  expire_date := add_months(today, period);
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.PUT_LINE('[DEBUG] Func generate_expire_date, expire date: ' || TO_CHAR(expire_date, 'DD-MON-YYYY'));
  END IF;
  RETURN expire_date;
EXCEPTION
WHEN no_data_found THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] Func generate_expire_date, exception no data found');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('[DEBUG] Func generate_expire_date, exception');
END generate_expire_date;
END GENERATED_DATA;
/
-- #############################################################
-- ######################## cards methods #####################################
-- #############################################################
CREATE OR REPLACE
PACKAGE cards_methods
AS
  -- it return card id via name and surname of the customer
FUNCTION card_id_for_customer(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type)
  RETURN customer.id_customer%type;
  -- it inserting record into card table when the customer exist in customer table
PROCEDURE get_card_for_user(
    fname$  IN customer.fname%type,
    lname$  IN customer.lname%type,
    period$ IN card.period%type);
  -- update the visit counter each tam the customer is use the room
PROCEDURE update_visit_in_card(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type);
END cards_methods;
/
CREATE OR REPLACE
PACKAGE body cards_methods
AS
  /*
  method will generate card for customer
  @param fname$ first name which have to exist in customer tabel
  @param lname$ last name also have to exist in customer table
  @param period$ integer which represent the months, after this period card will expire
  */
PROCEDURE get_card_for_user(
    fname$  IN customer.fname%type,
    lname$  IN customer.lname%type,
    period$ IN card.period%type)
AS
  id_card$ card.id_card%type;
  hname card.holder_name%type;
  count_v card.count_visit%type;
  id_cust$ customer.id_customer%type;
BEGIN
  hname := concat(fname$, ' ');
  hname := concat(hname, lname$);
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG] Proc cards_methods holder_name: '|| hname);
  END IF;
  SELECT cus.id_customer
  INTO id_cust$
  FROM customer cus
  WHERE cus.fname = fname$
  AND cus.lname   = lname$;
  INSERT INTO card
    (holder_name, period
    ) VALUES
    (hname, period$
    );
  SELECT c.count_visit INTO count_v FROM card c WHERE c.holder_name = hname;
  count_v := count_v + 1;
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG] Proc cards_methods add one count_v: '|| count_v);
  END IF;
  UPDATE card SET count_visit = count_v WHERE holder_name = hname;
  IF id_cust$ IS NOT NULL THEN
    SELECT id_card INTO id_card$ FROM card WHERE holder_name = hname;
    UPDATE customer SET id_card = id_card$ WHERE id_customer = id_cust$;
  END IF;
EXCEPTION
WHEN too_many_rows THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc cards_methods exception too many rows ');
WHEN no_data_found THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc cards_methods exception no data found ');
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc cards_methods some exception occure');
END get_card_for_user;
/*
this procedure is update the counter of visits
@param fname first name
@param lname last name
*/
PROCEDURE update_visit_in_card(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type)
AS
  id_card$ customer.id_card%type;
  visit_value card.count_visit%type;
BEGIN
  SELECT id_card
  INTO id_card$
  FROM customer
  WHERE fname = fname$
  AND lname   = lname$;
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG] Proc update_visit_in_card id_card$: <'|| id_card$ || '>');
  END IF;
  SELECT count_visit INTO visit_value FROM card WHERE id_card = id_card$;
  visit_value := visit_value + 1;
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG] Proc update_visit_in_card add one visit_value: '|| visit_value);
  END IF;
  IF visit_value > 20 AND visit_value < 30 THEN
    UPDATE card
    SET count_visit = visit_value,
      discount      = 0.2
    WHERE id_card   = id_card$;
  elsif visit_value > 30 AND visit_value < 50 THEN
    UPDATE card
    SET count_visit = visit_value,
      discount      = 0.4
    WHERE id_card   = id_card$;
  elsif visit_value > 50 THEN
    UPDATE card
    SET count_visit = visit_value,
      discount      = 0.6
    WHERE id_card   = id_card$;
  ELSE
    UPDATE card SET count_visit = visit_value WHERE id_card = id_card$;
  END IF;
EXCEPTION
WHEN too_many_rows THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc update_visit_in_card exception too many rows ');
WHEN no_data_found THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc update_visit_in_card exception no data found ');
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line('[DEBUG] Proc update_visit_in_card some exception occure');
END update_visit_in_card;
FUNCTION card_id_for_customer(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type)
  RETURN customer.id_customer%type
AS
  id_cust$ customer.id_customer%type;
BEGIN
  SELECT id_customer
  INTO id_cust$
  FROM customer
  WHERE fname = fname$
  AND lname   = lname$;
  RETURN id_cust$;
EXCEPTION
WHEN too_many_rows THEN
  DBMS_OUTPUT.put_line('[DEBUG] Func card_id_for_customer exception too many rows ');
WHEN no_data_found THEN
  DBMS_OUTPUT.put_line('[DEBUG] Func card_id_for_customer exception no data found ');
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line('[DEBUG] Func card_id_for_customer some exception occure');
END card_id_for_customer;
END cards_methods;
/
-- ##############################################################################
-- ################################## room methods ############################################
-- ##############################################################################
CREATE OR REPLACE
PACKAGE room_methods
AS
FUNCTION customer_id(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type)
  RETURN customer.id_customer%type;
  -- it insert record to reservation table and
PROCEDURE make_reservation(
    fname$   IN customer.fname%type,
    lname$   IN customer.lname%type,
    id_room$ IN room.id_room%type,
    d_from   IN DATE,
    d_to     IN reservation.many_days%type);
PROCEDURE check_date(
    start_date IN DATE,
    end_date   IN DATE);
PROCEDURE check_taken_room(
    id_room$ IN room.id_room%type);
PROCEDURE cancel_reservation(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    start_date$ IN DATE);
PROCEDURE release_room(
    fname$   IN customer.fname%type,
    lname$   IN customer.lname%type,
    id_room$ IN room.id_room%type);
PROCEDURE add_deposit(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    start_date$ IN DATE,
    many_days$  IN NUMBER,
    id_box$     IN deposit_box.id_box%type);
PROCEDURE add_service(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    id_service$     IN customer_service.id_service%type);
END room_methods;
/
----- ############################### BODY ####################################
CREATE OR REPLACE
PACKAGE body room_methods
AS
  -- ###################################################################
  --
PROCEDURE make_reservation(
    fname$   IN customer.fname%type,
    lname$   IN customer.lname%type,
    id_room$ IN room.id_room%type,
    d_from   IN DATE,
    d_to     IN reservation.many_days%type)
AS
  id_cust$ customer.id_customer%type;
BEGIN
  room_methods.check_taken_room(id_room$);
  id_cust$ := cards_methods.card_id_for_customer(fname$, lname$);
  INSERT
  INTO reservation
    (
      start_date,
      many_days,
      id_room,
      id_customer
    )
    VALUES
    (
      d_from,
      d_to,
      id_room$,
      id_cust$
    );
END make_reservation;
-- #################################################################
PROCEDURE check_date
  (
    start_date IN DATE,
    end_date   IN DATE
  )
AS
  wrong_insert_param EXCEPTION;
  pragma exception_init(wrong_insert_param, -20122);
BEGIN
  IF start_date > end_date THEN
    raise wrong_insert_param;
  END IF;
EXCEPTION
WHEN wrong_insert_param THEN
  dbms_output.put_line('[DEBUG] Proc check_date start_date > end_date: ' || TO_CHAR(start_date, 'DD-MON-YYYY') || ' > ' || TO_CHAR(end_date, 'DD-MON-YYYY'));
  raise_application_error(-20122, 'start_date > end_date <' || TO_CHAR(start_date, 'DD-MON-YYYY') || ' > ' || TO_CHAR(end_date, 'DD-MON-YYYY' || '>'));
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG] Proc check_date others exception occure ');
END check_date;
--################################################################
PROCEDURE check_taken_room
  (
    id_room$ IN room.id_room%type
  )
AS
  room_taken EXCEPTION;
  taken$ room.taken%type;
  pragma exception_init(room_taken, -20123);
BEGIN
  SELECT taken INTO taken$ FROM room WHERE id_room = id_room$;
  IF taken$ = 1 THEN
    raise room_taken;
  END IF;
EXCEPTION
WHEN room_taken THEN
  dbms_output.put_line('[DEBUG] Proc check_taken_room room_taken taken: <' || taken$ || '>');
  raise_application_error(-20123, 'room is taken');
WHEN no_data_found THEN
  dbms_output.put_line('[DEBUG] Proc check_taken_room no_data_found taken: <' || taken$ || '>');
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG] Proc check_taken_room others exception occure ');
END check_taken_room;
-- ###################################################################
-- getting the customer id via first name and last name
FUNCTION customer_id(
    fname$ IN customer.fname%type,
    lname$ IN customer.lname%type)
  RETURN customer.id_customer%type
AS
  id_cust$ customer.id_customer%type;
BEGIN
  SELECT id_customer
  INTO id_cust$
  FROM customer
  WHERE fname= fname$
  AND lname  = lname$;
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG] Func customer_id id_cust$: '|| id_cust$);
  END IF;
  RETURN id_cust$;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('[DEBUG] Func customer_id customer not exist exception ...');
  raise;
WHEN too_many_rows THEN
  dbms_output.put_line('[DEBUG] Func customer_id too many rows exception ...');
  raise;
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG] Func customer_id others exception ...');
END customer_id;
-- #############################################################################
PROCEDURE cancel_reservation(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    start_date$ IN DATE)
AS
  id_cust$ customer.id_customer%type;
BEGIN
  id_cust$ := customer_id(fname$, lname$);
  DELETE
  FROM reservation
  WHERE id_customer     = id_cust$
  AND TRUNC(start_date) = TO_CHAR(start_date$, 'DD-MON-YYYY');
  IF debuging_mode.debug_mode THEN
    DBMS_OUTPUT.put_line('[DEBUG]  Proc cancel_reservation: id_cust$: '|| id_cust$);
  END IF;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG] Proc cancel_reservation others exception ...');
END cancel_reservation;
-- ######################################################################################
PROCEDURE release_room(
    fname$   IN customer.fname%type,
    lname$   IN customer.lname%type,
    id_room$ IN room.id_room%type)
AS
  id_cust$ customer.id_customer%type;
BEGIN
  id_cust$ := customer_id(fname$, lname$);
  DELETE FROM reservation WHERE id_customer = id_cust$ AND id_room = id_room$;
  UPDATE room SET taken = 0 WHERE id_room = id_room$;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('[DEBUG] Proc release_room no_data_found exception ...');
WHEN dup_val_on_index THEN
  dbms_output.put_line('[DEBUG] Proc release_room dup_val_on_index exception ...');
WHEN OTHERS THEN
  dbms_output.put_line('[DEBUG] Proc release_room others exception ...');
END release_room;
PROCEDURE add_deposit(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    start_date$ IN DATE,
    many_days$  IN NUMBER,
    id_box$     IN deposit_box.id_box%type)
AS
  id_cust$ customer.id_customer%type;
  bill$ registry.bill%type;
BEGIN
  id_cust$ := room_methods.customer_id(fname$, lname$);
  SELECT price INTO bill$ FROM deposit_box WHERE id_box = id_box$;
  IF id_cust$ IS NOT NULL THEN
    bill$ := bill$ * many_days$;
    INSERT
    INTO registry
      (
        id_room,
        id_customer,
        from_date,
        to_date,
        bill,
        id_deposit
      )
      VALUES
      (
        0,
        id_cust$,
        start_date$,
        start_date$ + many_days$,
        bill$,
        id_box$
      );
  END IF;
END add_deposit;

PROCEDURE add_service(
    fname$      IN customer.fname%type,
    lname$      IN customer.lname%type,
    id_service$     IN customer_service.id_service%type)
AS
  id_cust$ customer.id_customer%type;
  bill$ registry.bill%type;
BEGIN
  id_cust$ := room_methods.customer_id(fname$, lname$);
  SELECT price INTO bill$ FROM customer_service WHERE id_service = id_service$;
  IF id_cust$ IS NOT NULL THEN
    INSERT
    INTO registry
      (
        id_room,
        id_customer,
        bill,
        id_services
      )
      VALUES
      (
        0,
        id_cust$,
        bill$,
        id_service$
      );
  END IF;
END add_service;

END room_methods;
/
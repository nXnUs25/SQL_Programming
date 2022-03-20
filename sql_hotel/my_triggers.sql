CREATE OR REPLACE TRIGGER card_expire_date before
  INSERT OR
  UPDATE ON card FOR EACH row DECLARE period INTEGER;
  BEGIN
    SELECT :new.period INTO period FROM dual;
    IF debuging_mode.debug_mode THEN
      DBMS_OUTPUT.put_line('[DEBUG] Trigger card_expire_date period: ' || period);
    END IF;
    IF :new.expired_date IS NULL THEN
      SELECT GENERATED_DATA.generate_expire_date(period)
      INTO :new.expired_date
      FROM dual;
    END IF;
    IF debuging_mode.debug_mode THEN
      DBMS_OUTPUT.put_line('[DEBUG] Trigger card_expire_date done...');
    END IF;
  END card_expire_date;
  /
CREATE OR REPLACE TRIGGER card_id before
  INSERT ON card FOR EACH row BEGIN IF :new.id_card IS NULL THEN
  SELECT seq_card_id.nextval INTO :new.id_card FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger card_id done...');
END IF;
END card_id;
/
CREATE OR REPLACE TRIGGER category_id before
  INSERT ON category_room FOR EACH row BEGIN IF :new.id_category IS NULL THEN
  SELECT seq_category_id.nextval INTO :new.id_category FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger category_id done...');
END IF;
END category_id;
/
CREATE OR REPLACE TRIGGER customer_id before
  INSERT ON customer FOR EACH row BEGIN IF :new.id_customer IS NULL THEN
  SELECT seq_customer_id.nextval INTO :new.id_customer FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger customer_id done...');
END IF;
END customer_id;
/
CREATE OR REPLACE TRIGGER customer_service_id before
  INSERT ON customer_service FOR EACH row BEGIN IF :new.id_service IS NULL THEN
  SELECT seq_customer_service_id.nextval INTO :new.id_service FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger customer_service_id done...');
END IF;
END customer_service_id;
/
CREATE OR REPLACE TRIGGER deposit_box_id before
  INSERT ON deposit_box FOR EACH row BEGIN IF :new.id_box IS NULL THEN
  SELECT seq_deposit_box_id.nextval INTO :new.id_box FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger deposit_box_id done...');
END IF;
END deposit_box_id;
/
CREATE OR REPLACE TRIGGER registry_id before
  INSERT ON registry FOR EACH row BEGIN IF :new.id_registry IS NULL THEN
  SELECT seq_registry_id.nextval INTO :new.id_registry FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger registry_id done...');
END IF;
END registry_id;
/
CREATE OR REPLACE TRIGGER reservation_id before
  INSERT ON reservation FOR EACH row BEGIN IF :new.id_reservation IS NULL THEN
  SELECT seq_reservation_id.nextval INTO :new.id_reservation FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger reservation_id done...');
END IF;
END reservation_id;
/
CREATE OR REPLACE TRIGGER room_id before
  INSERT ON room FOR EACH row BEGIN IF :new.id_room IS NULL THEN
  SELECT seq_room_id.nextval INTO :new.id_room FROM dual;
END IF;
IF debuging_mode.debug_mode THEN
  DBMS_OUTPUT.put_line('[DEBUG] Trigger room_id done...');
END IF;
END room_id;
/
CREATE OR REPLACE TRIGGER update_room_reservation AFTER
  INSERT ON reservation FOR EACH row DECLARE taken$ room.taken%type;
  BEGIN
    IF CURRENT_DATE = :new.start_date THEN
      SELECT taken INTO taken$ FROM room WHERE id_room = :new.id_room;
      IF debuging_mode.debug_mode THEN
        DBMS_OUTPUT.put_line('[DEBUG] Trigger update_room_reservation :new.id_room: ' || :new.id_room || ' taken: ' || taken$);
      END IF;
      IF taken$ != 1 THEN
        UPDATE room SET taken = 1 WHERE id_room = :new.id_room;
      END IF;
    ELSE
      IF debuging_mode.debug_mode THEN
        DBMS_OUTPUT.put_line('[DEBUG] Trigger update_room_reservation current_date != :new.start_date ' || TO_CHAR(CURRENT_DATE, 'DD-MON-YYYY') || ' = ' || TO_CHAR(:new.start_date, 'DD-MON-YYYY'));
      END IF;
    END IF;
  END update_room_reservation;
  /
CREATE OR REPLACE TRIGGER add_room_to_category AFTER
  INSERT ON category_room FOR EACH row DECLARE beds$ room.beds%type;
  BEGIN
    IF :new.id_category IS NOT NULL THEN
      UPDATE room SET id_category = :new.id_category WHERE beds = :new.id_category;
      IF debuging_mode.debug_mode THEN
        DBMS_OUTPUT.put_line('[DEBUG] Trigger add_room_to_category done...[:new.id_category]: <' || :new.id_category || '>');
      END IF;
    END IF;
  END add_room_to_category;
  /
CREATE OR REPLACE TRIGGER add_to_registry AFTER
  INSERT OR
  UPDATE ON reservation FOR EACH row DECLARE bill$ registry.bill%type;
  BEGIN
    IF :new.id_reservation IS NOT NULL THEN
      SELECT price_per_day INTO bill$ FROM room WHERE id_room = :new.id_room;
      bill$ := bill$ * :new.many_days;
      INSERT
      INTO registry
        (
          id_room,
          id_customer,
          from_date,
          to_date,
          bill
        )
        VALUES
        (
          :new.id_room,
          :new.id_customer,
          :new.start_date,
          :new.start_date + :new.many_days,
          bill$
        );
    END IF;
    IF debuging_mode.debug_mode THEN
      DBMS_OUTPUT.put_line('[DEBUG] Trigger add_to_registry done...');
    END IF;
  END add_to_registry;
  /
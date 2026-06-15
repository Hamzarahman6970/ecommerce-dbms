CREATE OR REPLACE PROCEDURE place_order(
    p_user_id    INT,
    p_product_id INT,
    p_quantity   INT,
    p_pay_method VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price    NUMERIC(10,2);
    v_stock    INT;
    v_total    NUMERIC(12,2);
    v_order_id INT;
BEGIN
    SELECT price, stock INTO v_price, v_stock
    FROM Products WHERE product_id = p_product_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product ID % not found.', p_product_id;
    END IF;

    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock. Available: %, Requested: %', v_stock, p_quantity;
    END IF;

    v_total := v_price * p_quantity;

    INSERT INTO Orders (user_id, order_date, total_amount)
    VALUES (p_user_id, NOW(), v_total)
    RETURNING order_id INTO v_order_id;

    INSERT INTO Order_Items (order_id, product_id, quantity, price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price);

    INSERT INTO Payments (order_id, payment_method, payment_status)
    VALUES (v_order_id, p_pay_method, 'Pending');

    RAISE NOTICE 'Order #% placed! Total: PKR %', v_order_id, v_total;
END;
$$;

CREATE OR REPLACE PROCEDURE update_stock(
    p_product_id INT,
    p_add_qty    INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_name  VARCHAR;
    v_stock INT;
BEGIN
    IF p_add_qty <= 0 THEN
        RAISE EXCEPTION 'Quantity must be positive.';
    END IF;

    SELECT name, stock INTO v_name, v_stock
    FROM Products WHERE product_id = p_product_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product ID % not found.', p_product_id;
    END IF;

    UPDATE Products
    SET stock = stock + p_add_qty
    WHERE product_id = p_product_id;

    RAISE NOTICE 'Stock for "%" updated: % to %',
        v_name, v_stock, (v_stock + p_add_qty);
END;
$$;

CREATE OR REPLACE FUNCTION fn_reduce_stock()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_current_stock INT;
BEGIN
    SELECT stock INTO v_current_stock
    FROM Products WHERE product_id = NEW.product_id;

    IF v_current_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Only % unit(s) in stock for product_id %.', v_current_stock, NEW.product_id;
    END IF;

    UPDATE Products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_reduce_stock ON Order_Items;
CREATE TRIGGER trg_reduce_stock
    AFTER INSERT ON Order_Items
    FOR EACH ROW
    EXECUTE FUNCTION fn_reduce_stock();

CREATE OR REPLACE FUNCTION fn_validate_payment()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        IF OLD.payment_status = 'Completed' AND NEW.payment_status = 'Pending' THEN
            RAISE EXCEPTION 'Cannot revert Completed payment to Pending for order_id %.', OLD.order_id;
        END IF;
    END IF;
    RAISE NOTICE 'Payment for order #%: status = %', NEW.order_id, NEW.payment_status;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validate_payment ON Payments;
CREATE TRIGGER trg_validate_payment
    BEFORE INSERT OR UPDATE ON Payments
    FOR EACH ROW
    EXECUTE FUNCTION fn_validate_payment();

CALL place_order(2, 6, 3, 'EasyPaisa');
CALL update_stock(6, 20);
SELECT product_id, name, stock FROM Products WHERE product_id = 6;

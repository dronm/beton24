-- Function: sup_make_orders()

-- DROP FUNCTION sup_make_orders();

CREATE OR REPLACE FUNCTION sup_make_orders()
  RETURNS void AS
$BODY$
	DELETE FROM supplier_orders WHERE date=now()::date+'1 day'::interval;
	
	INSERT INTO supplier_orders
	(date,supplier_id,material_id,quant,vehicles)
	(
		SELECT
			pp.shift::date AS shift,
			pp.supplier_id,
			pp.material_id,
			pp.quant_to_order,
			pp.vehicles_to_order
		FROM supplier_orders_list(
			--начало месяца
			date_trunc('month', current_date)::timestamp+const_first_shift_start_time_val(),
			--дата заказа - завтра конец смены
			get_shift_end(current_date::date+'1 day'::interval),
			--все материалы
			NULL
		) pp
		WHERE pp.shift::date=(current_date::date+'1 day'::interval)
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sup_make_orders() OWNER TO beton;

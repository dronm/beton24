<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:import href="Controller_php.xsl"/><!-- --><xsl:variable name="CONTROLLER_ID" select="'Shipment'"/><!-- --><xsl:output method="text" indent="yes"			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>			<xsl:template match="/">	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/></xsl:template><xsl:template match="controller"><![CDATA[<?php]]><xsl:call-template name="add_requirements"/>require_once('models/ShipmentRep_Model.php');require_once('models/ShipmentOperator_Model.php');require_once('models/ShipmentForOrderList_Model.php');require_once('models/ShipmentPumpList_Model.php');require_once('models/ShipmentTimeList_Model.php');require_once('controllers/Widget_Controller.php');require_once('common/SMSService.php');require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');require_once(FRAME_WORK_PATH.'basic_classes/FieldSQL.php');require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{	public function __construct($dbLinkMaster=NULL){		parent::__construct($dbLinkMaster);<xsl:apply-templates/>	}	public function shipment_report(){		$model = new ShipmentRep_Model($this->getDbLink());		$pm = $this->getPublicMethod('shipment_report');						$from = null; $count = null;		$limit = $this->limitFromParams($pm,$from,$count);		$calc_total = ($count>0);		if ($from){			$model->setListFrom($from);		}		if ($count){			$model->setRowsPerPage($count);		}				$order = $this->orderFromParams($pm,$model);		$where = $this->conditionFromParams($pm,$model);		$fields = $this->fieldsFromParams($pm);				$grp_fields = $this->grpFieldsFromParams($pm);				$agg_fields = $this->aggFieldsFromParams($pm);							$model->select(false,$where,$order,			$limit,$fields,$grp_fields,$agg_fields,			$calc_total,TRUE);		//		$this->addModel($model);			}	public function insert(){		$pm = $this->getPublicMethod("insert");		$pm->setParamValue("user_id",$_SESSION['user_id']);		parent::insert();	}	public function delete(){		$pm = $this->getPublicMethod("delete");		Widget_Controller::clearPlantLoadCacheOnShipId(			$this->getDbLink(),$pm->getParamValue("id")		);					parent::delete();	}	public function shipment_invoice(){		$link = $this->getDbLink();		$model = new ModelSQL($link,array("id"=>"ShipmentInvoice_Model"));		$model->addField(new FieldSQL($link,null,null,"number",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"month_str",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"day",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"year",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"time",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"client_descr",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"client_tel",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"concrete_type_descr",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"quant",DT_FLOAT));		$model->addField(new FieldSQL($link,null,null,"destination_descr",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"driver_descr",DT_STRING));		$model->addField(new FieldSQL($link,null,null,"vehicle_descr",DT_STRING));				$pm = $this->getPublicMethod('shipment_invoice');		$shipment_id = $pm->getParamValue('id');		$model->setSelectQueryText(		sprintf(		"SELECT order_num(o) AS number,			get_month_rus(sh.date_time::date) AS month_str,			EXTRACT(DAY FROM sh.date_time::date) AS day,			EXTRACT(YEAR FROM sh.date_time::date) AS year,			CASE WHEN				date_part('hour',sh.date_time) &lt; 10 THEN 				'0' || date_part('hour',sh.date_time)::text				ELSE date_part('hour',sh.date_time)::text			END || '-' ||			CASE WHEN				date_part('minute',sh.date_time) &lt; 10 THEN 				'0' || date_part('minute',sh.date_time)::text				ELSE date_part('minute',sh.date_time)::text			END AS time,			ct.name AS concrete_type_descr,			cl.name_full AS client_descr,			o.phone_cel AS client_tel,			sh.quant AS quant,			dest.name AS destination_descr,			dr.name AS driver_descr,			coalesce(vh.make || ' ','') || vh.plate AS vehicle_descr		FROM shipments AS sh		LEFT JOIN orders AS o ON o.id = sh.order_id		LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id		LEFT JOIN destinations AS dest ON dest.id = o.destination_id		LEFT JOIN clients AS cl ON cl.id = o.client_id		LEFT JOIN vehicle_schedules AS vs ON vs.id = sh.vehicle_schedule_id		LEFT JOIN drivers AS dr ON dr.id = vs.driver_id		LEFT JOIN vehicles AS vh ON vh.id = vs.vehicle_id		WHERE sh.id=%d"		,$shipment_id));				$model->select(false,null,null,			null,null,null,null,null,TRUE);		//		$this->addModel($model);				}			public function get_list_for_order($pm){		$this->modelGetList(new ShipmentForOrderList_Model($this->getDbLink()),			$pm		);	}	public function get_pump_list($pm){		$this->modelGetList(new ShipmentPumpList_Model($this->getDbLink()),			$pm		);	}	public function get_shipment_date_list($pm){		$this->modelGetList(new ShipmentDateList_Model($this->getDbLink()),			$pm		);	}	public function get_time_list($pm){		$this->modelGetList(new ShipmentTimeList_Model($this->getDbLink()),			$pm		);	}	}<![CDATA[?>]]></xsl:template></xsl:stylesheet>
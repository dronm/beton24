<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ContactContactDetail'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

require_once(USER_CONTROLLERS_PATH.'Contact_Controller.php');
require_once(USER_CONTROLLERS_PATH.'ContactDetail_Controller.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function insert_contact_detail($pm){
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');
		try{				
			$contr = new ContactDetail_Controller($link,$link);
			$meth = $contr->getPublicMethod(ControllerDb::METH_INSERT);
			$meth->setParamValue('ret_id','1');
			$meth->setParamValue('name',$pm->getParamValue('name'));
			$meth->setParamValue('value',$pm->getParamValue('value'));
			$meth->setParamValue('contact_type',$pm->getParamValue('contact_type'));
			$ar = $contr->insert($meth);
			
			$meth = $this->getPublicMethod(ControllerDb::METH_INSERT);
			$meth->setParamValue('contact_detail_id',$ar['id']);
			$meth->setParamValue('contact_id',$pm->getParamValue('contact_id'));
			$meth->setParamValue('main',$pm->getParamValue('main'));
			parent::insert($pm);
			
			if ($pm->getParamValue('ret_id')){
				$fields = array();
				array_push($fields,new Field('contact_id',DT_STRING,array('value'=>$pm->getParamValue('contact_id'))));
				array_push($fields,new Field('contact_detail_id',DT_STRING,array('value'=>$ar['id'])));
				$this->addModel(new ModelVars(
					array('id'=>'LastIds',
						'values'=>$fields)
					)
				);				
			}
			
			$link->query("COMMIT");			
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}		
	}	
	public function insert_contact_with_contact_detail($pm){
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');
		try{	
			//новая контактная инф
			$contr = new ContactDetail_Controller($link,$link);
			$meth = $contr->getPublicMethod(ControllerDb::METH_INSERT);
			$meth->setParamValue('ret_id','1');
			$meth->setParamValue('name',$pm->getParamValue('detail_name'));
			$meth->setParamValue('value',$pm->getParamValue('detail_value'));
			$meth->setParamValue('contact_type',$pm->getParamValue('detail_contact_type'));
			$ar = $contr->insert($meth);
			$contact_detail_id = $ar['id'];
			
			//новый контакт
			$contr = new Contact_Controller($link,$link);
			$meth = $contr->getPublicMethod(ControllerDb::METH_INSERT);
			$meth->setParamValue('ret_id','1');
			$meth->setParamValue('first_name',$pm->getParamValue('first_name'));
			$meth->setParamValue('middle_name',$pm->getParamValue('middle_name'));
			$meth->setParamValue('last_name',$pm->getParamValue('last_name'));
			$meth->setParamValue('post',$pm->getParamValue('post'));
			$meth->setParamValue('description',$pm->getParamValue('description'));
			$ar = $contr->insert($meth);
			$contact_id = $ar['id'];
			
			//связывание
			$meth = $this->getPublicMethod(ControllerDb::METH_INSERT);
			$meth->setParamValue('contact_detail_id',$contact_detail_id);
			$meth->setParamValue('contact_id',$contact_id);
			$meth->setParamValue('main',$pm->getParamValue('main'));
			parent::insert($pm);
			
			if ($pm->getParamValue('ret_id')){
				$fields = array();
				array_push($fields,new Field('contact_id',DT_STRING,array('value'=>$contact_id)));
				array_push($fields,new Field('contact_detail_id',DT_STRING,array('value'=>$contact_detail_id)));
				$this->addModel(new ModelVars(
					array('id'=>'LastIds',
						'values'=>$fields)
					)
				);				
			}
			
			$link->query("COMMIT");			
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}		
	}	
	public function set_main($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		
		$link = $this->getDbLinkMaster();
		$link->query('BEGIN');
		try{
			//old mains
			$link->query(sprintf(
			"UPDATE contact_contact_details u
				SET main=FALSE
			FROM (
        		SELECT  cd.id
        		FROM contact_contact_details AS ccd
				LEFT JOIN contact_details AS cd ON cd.id=ccd.contact_detail_id
        		WHERE ccd.contact_id=%d AND ccd.main=TRUE
					AND cd.contact_type=(
						SELECT contact_type FROM contact_details WHERE id=%d
						)
    			) s
			WHERE s.id=u.contact_detail_id",
			$p->getDbVal('contact_id'),
			$p->getDbVal('contact_detail_id')
			));
	
			//new main
			$link->query(sprintf(
			"UPDATE contact_contact_details
				SET main=TRUE
			WHERE contact_id=%d
				AND contact_detail_id=%d",
			$p->getDbVal('contact_id'),
			$p->getDbVal('contact_detail_id')
			));			
			
			$link->query('COMMIT');
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}			
	}
	
</xsl:template>

</xsl:stylesheet>

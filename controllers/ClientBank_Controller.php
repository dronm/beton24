<?php

require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');

require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');

class ClientBank_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);
			
	/*Справочник банковских счетов клиента*/

			
		/* insert */
		$pm = new PublicMethod('insert');
		$param = new FieldExtInt('client_id'
				,array(
				'alias'=>'ID клиента'
			));
		$pm->addParam($param);
		$param = new FieldExtInt('bank_id'
				,array(
				'alias'=>'ID банка'
			));
		$pm->addParam($param);
		$param = new FieldExtString('account'
				,array(
				'alias'=>'Расчетный счет'
			));
		$pm->addParam($param);
		
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('ClientBank_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_client_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('old_bank_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		$param = new FieldExtInt('client_id'
				,array(
			
				'alias'=>'ID клиента'
			));
			$pm->addParam($param);
		$param = new FieldExtInt('bank_id'
				,array(
			
				'alias'=>'ID банка'
			));
			$pm->addParam($param);
		$param = new FieldExtString('account'
				,array(
			
				'alias'=>'Расчетный счет'
			));
			$pm->addParam($param);
		
			$param = new FieldExtInt('client_id',array(
			
				'alias'=>'ID клиента'
			));
			$pm->addParam($param);
		
			$param = new FieldExtInt('bank_id',array(
			
				'alias'=>'ID банка'
			));
			$pm->addParam($param);
		
		
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('ClientBank_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('client_id'
		));		
		
		$pm->addParam(new FieldExtInt('bank_id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('ClientBank_Model');

			
		/* get_list */
		$pm = new PublicMethod('get_list');
		$pm->addParam(new FieldExtInt('browse_mode'));
		$pm->addParam(new FieldExtInt('browse_id'));		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));				
		
		$this->addPublicMethod($pm);
		
		$this->setListModelId('ClientBankList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtInt('browse_mode'));
		
		$pm->addParam(new FieldExtInt('client_id'
		));
		
		$pm->addParam(new FieldExtInt('bank_id'
		));
		
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ClientBankList_Model');		

		
	}	
	
}
?>

package com.idzeir.flashviewer.context
{
	import com.idzeir.core.interfaces.IContext;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Alert;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	
	public class AlertMap implements IContext, IAlertMap
	{
		private var _alert:Alert;
		
		private var _alertStage:DisplayObjectContainer;
		
		private var _map:Array = [];

		private var isAlerting:Boolean;

		private var _curBack:Function;
		
		public function AlertMap()
		{
			
		}
		
		public function startUp(value:*=null):void
		{
			if(value is DisplayObjectContainer)
			{
				_alert = new Alert("11111","警告");
				_alert.visible = false;
				_alert.setWH(300,200);
			}
		}
		
		public function alert(msg:String,title:String = "提示信息",closeFun:Function = null):void
		{
			_map.push({"msg":msg,"title":title,"closeFun":closeFun});
			
			if(isAlerting)
			{
				return;
			}
			isAlerting = true;
			activeAlert();
		}
		
		private function activeAlert():void
		{
			if(_map.length==0)
			{
				isAlerting = false;
				Utils.mediator.send(Enum.ERROR_ALL_CLEAR);
				return;
			}
			var o:Object = _map.shift();
			_curBack = o.closeFun;
			_alert.updateInfo(o.msg,o.title,invoke);
			_alert.visible = true;	
			if(_alertStage.contains(_alert))
			{
				_alertStage.removeChild(_alert);
			}
			_alert.x = (_alertStage.width - _alert.width)>>1;
			_alert.y = (_alertStage.height - _alert.height)>>1;
			_alertStage.addChild(_alert);
			Utils.tween.fromTo(_alert,.5,{alpha:.5},{alpha:1});
		}
		
		private function invoke():void
		{
			_alert.visible = false;
			if(_curBack!=null)
			{
				_curBack.apply();				
			}
			_curBack = null
			setTimeout(activeAlert,500);
		}
		
		public function get warp():DisplayObject
		{
			return _alert;
		}
		
		public function set stage(value:DisplayObjectContainer):void
		{
			_alertStage = value;
		}
	}
}
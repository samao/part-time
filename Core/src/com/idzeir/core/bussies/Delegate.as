package com.idzeir.core.bussies
{	
	import com.idzeir.core.events.IMediator;
	import com.idzeir.core.utils.Utils;
	
	/**
	 * 模块代理基类
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 19, 2014 11:02:18 PM
	 *
	 **/
	
	public class Delegate implements IDelegate
	{
		/**
		 * 记载完成的模块 
		 */		
		protected var _view:IModule;
		/**
		 * 全局事件引用 
		 */		
		protected var _e:IMediator;
		/**
		 * 加载完成前的缓存消息 
		 */		
		protected var _handles:Vector.<Object>;
		
		protected var _url:String;
		
		public function Delegate(_warp:String=null)
		{
			_e = Utils.mediator;
			_handles = new Vector.<Object>();
			_url = _warp;
		}
		
		/**
		 * 执行函数入口，未加载模块之前可以缓存数据 
		 * @param handle
		 * @param value
		 * 
		 */		
		protected function excute(handle:Function,value:* = null):void
		{
			if(!_view)
			{
				_handles.push({"handle":handle,"value":value});
				return;
			}
			handle.apply(null,value?[value]:null);
		}
		/**
		 * 清空模块加载完成前的缓存数据
		 */		
		private function deal():void
		{
			while(this._handles.length>0)
			{
				var data:Object = this._handles.shift();
				var cmd:Function = data.handle;
				if(cmd!=null)
				{
					cmd.apply(null,data["value"]?[data["value"]]:null);
				}
			}
		}			
		
		public function onloaded(_warp:IModule):void
		{
			//1.赋值module
			this._view = _warp;
			//2.设置模块名称
			this._view.name = _url;
			//3.加载完成处理
			this._view.data = {"onload":null};
			//4.清理缓存数据
			deal();
			//5.注册ui监听
			addViewListener();
		}
		
		public function addViewListener():void
		{
			
		}
		
		public function unloaded():void
		{
			this._e = null;
			this._view = null;
			this._handles = null;
		}

		/**
		 * 代理模块的路径 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

	}
}
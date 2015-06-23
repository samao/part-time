package com.idzeir.core.bussies
{	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.idzeir.core.bussies.enum.FEnum;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 9:25:25 AM
	 *
	 **/
	
	public class DelegateManager implements IDelegateManager
	{
		private var _map:Vector.<IDelegate>;
		
		private var _queue:LoaderMax;
		
		public function DelegateManager()
		{
			_map = new Vector.<IDelegate>();
			_queue = new LoaderMax({name:"delegateManager", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
		}
		
		protected function progressHandler(e:LoaderEvent):void
		{
			
		}
		protected function errorHandler(e:LoaderEvent):void
		{
			trace("模块加载错误：",e.text);
		}
		protected function completeHandler(e:LoaderEvent):void
		{
			//trace("模块加载完成：",e.text);
			this._map.forEach(function(em:IDelegate,index:int,arr:Vector.<IDelegate>):void
			{
				var _warp:DisplayObject = _queue.getContent(em.url).rawContent as DisplayObject;
				em.onloaded(_warp as IModule);
				Utils.mediator.send(FEnum.FW_LOAD_COMPLETED,_warp);
			});
			Utils.mediator.send(FEnum.FW_ALL_LOADED);
		}
		
		public function register(value:IDelegate):void
		{
			if(indexOf(value) == -1)
			{
				_map.push(value);
				if(Utils.validateStr(value.url))
				{
					_queue.append(new SWFLoader(value.url,{name:value.url}));
				}				
			}
		}
		
		public function excute():void
		{
			_queue.load();
		}
		
		public function unRegister(value:IDelegate):void
		{
			var index:int = indexOf(value);
			if(index!=-1)
			{
				var delegate:IDelegate = _map.splice(index,1)[0];
				delegate.unloaded();
			}
		}
		/**
		 * 检测是否存在 
		 * @param value
		 * @return -1不存在否则返回该位置索引
		 * 
		 */		
		private function indexOf(value:IDelegate):int
		{
			for(var i:uint = 0;i<_map.length;i++)
			{
				if(_map[i].url == value.url)
				{
					return i;
				}
			}
			return -1;
		}
	}
}
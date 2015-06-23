package com.idzeir.livepush.module
{	
	
	import com.idzeir.core.bussies.IModule;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 3, 2014 6:05:41 PM
	 *
	 **/
	
	public class ModuleControler
	{
		static private var _instance:ModuleControler;
		
		private var _dic:Dictionary = new Dictionary(true);
		
		public function ModuleControler()
		{
			
		}
		
		static public function getControler():ModuleControler
		{
			if(!_instance)
			{
				_instance = new ModuleControler();
			}
			
			return _instance;
		}
		
		/**
		 * 获取key对应的模块单例live 或者 push
		 */
		public function module(key:String):IModule
		{
			var module:IModule;
			if(!_dic.hasOwnProperty(key))
			{
				switch(key)
				{
					case "live":
						module = new LiveModule();
						break;
					case "push":
						module = new PushModule();
						break;
				}
				_dic[key] = module;
			}else{
				module = _dic[key] as IModule;
			}
			
			return module
		}
	}
}
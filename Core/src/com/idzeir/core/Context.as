package com.idzeir.core
{	
	
	import com.idzeir.core.interfaces.IContext;
	
	import flash.utils.Dictionary;
	
	
	/**
	 * 上下文管理类
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Mar 7, 2014 1:02:51 AM
	 *
	 **/
	
	public class Context
	{
		static private var _dictionary:Dictionary=new Dictionary(true);
		
		static private var _variables:Object = new Object();
		
		public function Context()
		{
			throw new Error("非法调用");
		}
		
		/**
		 * 向内存中上传一个内容
		 * @param key 标识
		 * @param templete 实现IContext的模板或者实例
		 * @param arg 模板时候接受的参数
		 * 
		 */		
		static public function register(key:String, templete:*,arg:*=null):void
		{
			if(!_dictionary.hasOwnProperty(key))
			{
				var iContext:IContext
				if(templete is Class)
				{
					iContext=new templete() as IContext;
				}else{
					iContext=templete as IContext;
				}
				if(!iContext)
				{
					throw new Error("上传模板没有实现IContext接口");
					return;
				}
				iContext.startUp(arg);
				_dictionary[key]=iContext;
				return;
			}
			throw new Error("该键值已经存在");
		}
		
		/**
		 * 从内存中下载一个内容 
		 * @param key 标识
		 * @return 
		 */		
		static public function getContext(key:String):*
		{
			if(_dictionary.hasOwnProperty(key))
			{
				return _dictionary[key];
			}
			return null;
		}
		
		/**
		 * 上下文环境变量 从web获取的数据，url数据会覆盖flashvars数据
		 * @return 
		 */		
		public static function get variables():Object {
			return _variables;
		}
	}
}
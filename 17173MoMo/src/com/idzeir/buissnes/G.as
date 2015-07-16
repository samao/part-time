package com.idzeir.buissnes
{
	import com.idzeir.core.motion.ITween;
	import com.idzeir.manager.IRoomMgr;
	import com.idzeir.service.IHttp;
	
	import flash.events.IEventDispatcher;

	/**
	 * 全局服务接口
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class G
	{
		/**
		 * http 服务
		 */
		static public var h:IHttp;
		/**
		 * 本地事件服务
		 */
		static public var e:IEventDispatcher;
		/**
		 * 房间数据管理服务
		 */
		static public var r:IRoomMgr;
		/**
		 * 动画服务 
		 */		
		static public var t:ITween;
		
		/**
		 * 手机宽高 
		 */		
		static public const WIDTH:int = 480;
		
		static public const HEIGHT:int = 800;
	}
}
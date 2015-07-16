package com.idzeir.service
{
	/**
	 * http服务接口
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public interface IHttp
	{
		/**
		 * http post 请求
		 * @param url 接口地址
		 * @param params 传入参数
		 * @param ok 成功回调
		 * @param fail 失败回调
		 *
		 */
		function post(url:String, params:Object = null, ok:Function = null, fail:Function = null):void;
	}
}
package com.idzeir.flashviewer.context
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IAlertMap
	{
		/**
		 * 弹出alert 管理 
		 * @param msg 内容
		 * @param title 标题
		 * @param closeFun 点击关闭按钮后回调
		 * 
		 */		
		function alert(msg:String,title:String = "信息",closeFun:Function = null):void;
		
		/**
		 * 获取alert显示对象 
		 * @return 
		 * 
		 */		
		function get warp():DisplayObject;
		
		/**
		 * 设置alert的父容器 
		 * @param value
		 * 
		 */		
		function set stage(value:DisplayObjectContainer):void;
	}
}
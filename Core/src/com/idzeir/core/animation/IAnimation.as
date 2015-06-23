package com.idzeir.core.animation
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 24, 2014 1:36:47 PM
	 *
	 **/
	
	public interface IAnimation
	{
		/**
		 * 指定是否循环播放
		 * @param bool
		 */		
		function set loop(bool:Boolean):void;
		/**
		 * 播放 
		 * @param _fps 指定播放的帧速，0时为swf帧频
		 */		
		function play(_fps:uint = 0):void;
		/**
		 * 停止
		 */				
		function stop():void;
		/**
		 * 调到指定帧
		 * @param frame
		 */		
		function gotoAndStop(frame:*):void;
		/**
		 * 调到指定帧播放 
		 * @param frame
		 */		
		function gotoAndPlay(frame:*):void;
		
		/**
		 * 返回当前播放帧 
		 * @return 
		 */		
		function get currentFrame():uint;
		/**
		 * 返回动画总帧数
		 * @return 
		 */		
		function get totalFrame():uint;
		/**
		 * 从父容器删除动画
		 * @param bool 设置true时回收动画资源
		 */		
		function removeFromParent(bool:Boolean = false):void;
		/**
		 * 释放动画资源
		 */		
		function dispose():void;
		/**
		 * 指定播放动画的序列图素组 (bitmapdata数组)
		 * @param value
		 */		
		function set data(value:Array):void;
		/**
		 * 播放完毕的回调 
		 * @param handler
		 */		
		function set endCallBack(handler:Function):void;
		/**
		 * 播放到指定帧执行函数 
		 * @param value 帧
		 * @param handler 执行的回调
		 */		
		function addHandlerToFrame(value:uint,handler:Function):void;
		/**
		 * 删除帧回调 
		 * @param value
		 */		
		function removeHandlerToFrame(value:uint):void;
	}
}
package com.idzeir.view
{
	import flash.display.DisplayObject;

	public interface IRender
	{
		/**
		 * 返回显示对象
		 * @return
		 *
		 */
		function get warp():DisplayObject;
		/**
		 * 自适应舞台重绘大小
		 * @return 方便链式调用
		 */
		function resize():IRender;
	}
}
/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 30, 2015 1:44:17 PM			
 * ===================================
 */

package com.idzeir.core.bussies
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SceneElement extends Sprite
	{
		private var _content:DisplayObject;
		
		public function SceneElement()
		{
			
		}
		
		public static function create(value:DisplayObject):SceneElement
		{
			var element:SceneElement = new SceneElement();
			element._content = value;
			element.mouseEnabled = false;
			
			return element;
		}
		
		public function add():void
		{
			try{
				addChild(_content);
			}catch(e:Error){
				trace(e.message,"SceneElement没有使用工厂方式创建");
			}
		}
	}
}
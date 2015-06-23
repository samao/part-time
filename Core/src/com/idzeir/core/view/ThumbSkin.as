package com.idzeir.core.view
{
	import flash.display.Sprite;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-10  下午4:26:52
	 */
	internal class ThumbSkin extends Sprite
	{

		private var leftHead:Sprite;

		private var rightHead:Sprite;

		private var body:Sprite;
		
		private var _size:Number=50;
		
		private var box:Sprite=new Sprite();
		
		public function ThumbSkin()
		{
			super();
			this.mouseChildren = false;
			this.addChildren();
		}
		
		private function addChildren():void
		{
			this.addChild(box);
			
			leftHead=new Thumb_head();
			
			body=new Thumb_mid();
			
			rightHead=new Thumb_head();
			
			resize(50,0);
		}
		
		public function resize(size:Number,dir:uint=0):void
		{
			box.removeChildren();
			
			box.addChild(leftHead);
			box.addChild(body);
			box.addChild(rightHead);
			
			var tSize:Number=Math.max(size,2*leftHead.width);
			body.x=leftHead.width-1;
			body.width=tSize-2*leftHead.width+2;
			rightHead.scaleX=-1;
			rightHead.x=body.x+body.width-1+rightHead.width;
			
			switch(dir)
			{
				case 0:
					//水平
					
					break
				case 1:
					//垂直
					box.rotation=90;
					box.x=box.width;
					break;
			}
		}
	}
}
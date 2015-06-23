package com.idzeir.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class VirGiftShape extends Sprite 
	{
		private var dragRect:Rectangle;
		
		public function VirGiftShape() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this.mouseChildren = false;
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			this.graphics.lineStyle(2, 0x0000ff);
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(10, 10, 10);
			this.graphics.endFill();
			
			dragRect = new Rectangle(0, 0, stage.stageWidth - 10, stage.stageHeight - 10);
		}
		
		private function onPress(e:MouseEvent):void 
		{
			if (e.controlKey)
			{
				//copy
				var item:VirGiftShape = new VirGiftShape();
				LibPanel.getLib().icanvas.addItem(item);
				item.x = this.x;
				item.y = this.y;
				item.startDrag(false, dragRect);
				LibPanel.getLib().icanvas.select(item);
			}else if (e.shiftKey) {
				//删除点
				this.parent.removeChild(this);
				return;
			}else {
				//drag
				this.startDrag(false, dragRect);
				LibPanel.getLib().icanvas.select(this);
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);		
		}
		
		private function onRelease(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			this.stopDrag();
		}
		
	}

}
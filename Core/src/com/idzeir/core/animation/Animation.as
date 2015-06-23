package com.idzeir.core.animation
{	
	import com.idzeir.core.Context;
	import com.idzeir.core.interfaces.ITicker;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	/**
	 * 序列图动画 
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 24, 2014 1:53:28 PM
	 **/
	
	public class Animation extends Sprite implements IAnimation
	{
		private var _loop:Boolean = true;
		private var _bmds:Array = null;

		private var _curFrame:uint = 1;

		private var _bp:Bitmap;
		
		private var _fps:uint = 0;
		private var _lastFrame:uint = 0;
		
		/**
		 * 播放完毕回调 
		 */		
		private var frameEndBack:Dictionary = new Dictionary(true);
		private var isPlaying:Boolean = false;
		
		/**
		 * 序列图动画 
		 * @param data bitmapdata数组
		 */		
		public function Animation(_data:Array = null)
		{
			super();
			if(_data)this.data = _data;
		}
		
		static public function createSpriteSheet(mc:MovieClip):Array
		{
			var arr:Array = [];
			if(mc)
			{
				var total:uint = mc.totalFrames;
				var cur:uint = 1;
				var bd:BitmapData = null;
				var bound:Rectangle = null;
				var p:Point = new Point();
				var  _matrix:Matrix = new Matrix();
				var info:AnimationBitmapData = null;
				do{
					_matrix.identity();
					mc.gotoAndStop(cur);
					bound = mc.getBounds(mc);
					_matrix.translate(-bound.x,-bound.y);
					if(bound.isEmpty())
					{
						if(arr.length>0)
						{
							info = (arr[arr.length -1] as AnimationBitmapData).cloneAnimation() as AnimationBitmapData;
						}else{
							info = new AnimationBitmapData(1,1,true,0x00000000);
						}
					}else{
						bd = new BitmapData(mc.width,mc.height,true,0x00000000);
						bd.draw(mc,_matrix);
						
						var drawRect:Rectangle = bd.getColorBoundsRect(0xff000000,0x00000000,false);
						if(drawRect && !drawRect.isEmpty() && (bd.width != drawRect.width || bd.height != drawRect.height))
						{
							info = new AnimationBitmapData(drawRect.width,drawRect.height,true,0x00000000);
							info.copyPixels(bd,drawRect,p);
							info.offsetX = drawRect.left;
							info.offsetY = drawRect.top;
						}else{
							info = new AnimationBitmapData(bd.width,bd.height,true,0x00000000);
							info.copyPixels(bd,bd.rect,p);
						}
						info.x = bound.x;
						info.y = bound.y;
						drawRect.setEmpty();
						bd.dispose();
					}
					info.frameLabel = mc.currentFrameLabel;
					arr.push(info);
					cur++;
				}while(cur<=total);
				
			}
			
			return arr;
		}
		
		public function set data(value:Array):void
		{
			if(!value||value.length==0)
			{
				return;
			}
			if(!_bp)
			{
				_bp = new Bitmap;
				this.addChild(_bp);
			}
			this._bmds = value;
			gotoAndStop(1);
		}
		
		public function set loop(bool:Boolean):void
		{
			_loop = bool;
		}
		
		public function play(_fps:uint = 0):void
		{
			if(this._bmds && this._bmds.length>1&&!this.isPlaying)
			{
				isPlaying = true;
				this._fps = _fps == 0 ? 24 : _fps;
				(Context.getContext("ticker") as ITicker).call(1000/this._fps,runAnimation);
			}
		}
		
		private function runAnimation(value:* = null):void
		{
			if(!this._bmds||!isPlaying)return;
			
			showInfo = this._bmds[_curFrame-1];
			trace("当前帧：",_curFrame);
			//派发播放完毕时间
			if(this._curFrame == this._bmds.length)
			{
				//派发事件
				if(this.hasEventListener(Event.COMPLETE))
				{
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
				if(!_loop)
				{
					stop();
				}else{
					this._curFrame = 1;
				}				
				return;
			}
			_curFrame ++;
		}
		
		public function set endCallBack(handler:Function):void
		{
			this.frameEndBack[this._bmds.length] = handler;
		}
		
		public function stop():void
		{
			if(isPlaying)
			{
				(Context.getContext("ticker") as ITicker).remove(runAnimation);
			}
			isPlaying = false;
		}
		
		public function gotoAndStop(frame:*):void
		{
			if(frame is String)
			{
				gotoLabel(frame);
			}else{
				if(frame<this._bmds.length)
				{
					this._curFrame = frame;
					showInfo = this._bmds[frame-1];
				}
			}
			stop();
		}
		
		private function gotoLabel(label:String):void
		{
			for(var i:uint = 0;i<this._bmds.length;i++)
			{
				if(_bmds[i].frameLabel == label)
				{
					this._curFrame = i+1;
					showInfo = _bmds[i];
					return;
				}
			}
		}
		
		private function set showInfo(value:AnimationBitmapData):void
		{
			this._bp.bitmapData = value;
			this._bp.x = value.offsetX;
			this._bp.y = value.offsetY;
			_lastFrame = this._curFrame;
			var handler:Function = this.frameEndBack[this._curFrame];
			if(handler!=null)
			{
				handler.apply();
			}
		}
		
		public function removeHandlerToFrame(value:uint):void
		{
			this.frameEndBack[value] = null;
		}
		
		public function addHandlerToFrame(value:uint, handler:Function):void
		{
			this.frameEndBack[value] = handler;
		}
		
		public function gotoAndPlay(frame:*):void
		{
			if(frame is String)
			{
				gotoLabel(frame);
			}else{
				if(frame>this._bmds.length)
				{
					this._curFrame = frame;
					showInfo = this._bmds[frame-1];
				}
			}
			play(this._fps);
		}
		
		public function get currentFrame():uint
		{
			return this._curFrame;
		}
		
		public function get totalFrame():uint
		{
			return this._bmds?_bmds.length:0;
		}
		
		public function removeFromParent(bool:Boolean=false):void
		{
			if(this.parent)
			{
				parent.removeChild(this);
				if(bool)
				{
					this.dispose();
				}
			}
		}
		
		public function dispose():void
		{
			if(isPlaying)
			{
				stop();
			}
			this._bmds = null;
			_loop = true;
			_curFrame = 1;
			_lastFrame = 0;
			this.removeChildren();
			if(this._bp)
			{
				this._bp = null;
			}
			for(var i:* in this.frameEndBack)
			{
				delete this.frameEndBack[i];
			}
		}
	}
}
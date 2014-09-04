package com.astrazeneca
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PopUp extends ClipSprite
	{
		private var bg:Quad;
		private var content:Sprite;
		
		public function PopUp(image:Image, contentX:int, contentY:int, closeRect:Rectangle)
		{
			super(image.width);
						
			bg = new Quad(1080, 1920, 0xffffff);
			addChild(bg);
			
			content = new Sprite();
			content.addChild(image);
			content.x = contentX;
			content.y = contentY;
			content.clipRect = new Rectangle(0,0,0,image.height);
			addChild(content);
			
			var closeBtn:Quad = new Quad(closeRect.width, closeRect.height, 0xff0000);
			closeBtn.alpha = 0;//.5;
			closeBtn.x = closeRect.x;
			closeBtn.y = closeRect.y;
			closeBtn.touchable = true;
			closeBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			content.addChild(closeBtn);
			
			//this.alpha = 0;
			this.touchable = false;
		}
		
		public function show():void
		{
			TweenMax.to(bg, .4, {autoAlpha:.7, ease:Sine.easeOut});
			TweenMax.to(content.clipRect, 1, {width:originalWidth, ease:Sine.easeOut});
			this.touchable = true;
		}
		
		public function hide():void
		{
			TweenMax.to(bg, .2, {autoAlpha:0, ease:Sine.easeOut});
			TweenMax.to(content.clipRect, .4, {width:0, ease:Sine.easeOut});
			this.touchable = false;
			dispatchEventWith("HIDING", true);
		}
		
		public function reset():void
		{
			content.clipRect.width = 0;
			bg.alpha = 0;
			bg.visible = false;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase == TouchPhase.BEGAN) {
				hide();
			}
		}
	}
}
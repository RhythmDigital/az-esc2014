package com.astrazeneca.starling
{	
	import com.greensock.TweenMax;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class StarlingQuadButton extends Quad
	{
		public static const TOUCHED:String = "touched";
		public static const TOUCHED_AFTER:String = "touched_after";
		private var id:String;
		public function StarlingQuadButton(id:String, width:Number, height:Number, color:uint=0xffffff, premultipliedAlpha:Boolean=true)
		{
			this.id = id;
			super(width, height, color, premultipliedAlpha);
			alpha = 0;
			
			touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase == TouchPhase.BEGAN) {
				dispatchEvent(new Event(StarlingQuadButton.TOUCHED, true, {id:id}));
				TweenMax.delayedCall(10, notifyPostClick, null, true);
			}
		}
		
		private function notifyPostClick():void
		{
			dispatchEvent(new Event(StarlingQuadButton.TOUCHED_AFTER, true, {id:id}));
		}
	}
}
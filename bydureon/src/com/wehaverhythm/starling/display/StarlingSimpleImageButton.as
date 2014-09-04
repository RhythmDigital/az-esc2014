package com.wehaverhythm.starling.display
{
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class StarlingSimpleImageButton extends Sprite
	{
		public function StarlingSimpleImageButton()
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase == TouchPhase.BEGAN) dispatchEventWith("TOUCHED", true);
		}
	}
}
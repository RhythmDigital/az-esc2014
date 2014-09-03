package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class RFID extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		
		public function RFID()
		{
			super();
			
			imageManifest = [];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			quad = new Quad(1080, 1920, 0x0000ff);
			addChild(quad);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.insert(TweenMax.to(quad, 1, {alpha:1}));
			reset();
		}
		
		private function onTransitionComplete():void
		{
			transitioning = OPEN;
		}
		
		private function onReverseTransitionComplete():void
		{
			transitioning = CLOSED;
			TweenMax.to(this, .2, {alpha:0, ease:Sine.easeIn});
			notifyScreenClosed();
		}
		
		override public function show():void
		{
			super.show();
			
			transitioning = OPENING;
			timeline.timeScale(.7);
			timeline.play();
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
		}
		
		override public function reset():void
		{
			quad.alpha = 0;
		}
	}
}
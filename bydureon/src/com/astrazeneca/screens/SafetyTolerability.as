package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class SafetyTolerability extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		
		public function SafetyTolerability()
		{
			super();
			
			var path:String = "safetyTolerability/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:10, y:96, clipSprite:false, name:'sTwhiteBG' }
				,	{ img: path+'greenSwoosh.png', x:44, y:0, clipSprite:true, name:'sTgreenSwoosh' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['sTwhiteBG']);
			addChild(images['sTgreenSwoosh']);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append( TweenMax.to(images['sTwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['sTgreenSwoosh'].clipRect, 1, { width:images['sTgreenSwoosh'].originalWidth, ease:Sine.easeOut }) );
			reset();
			notifyReady();
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
			images['sTwhiteBG'].x = -1080;
			images['sTgreenSwoosh'].clipRect.width = 0;
		}
	}
}
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
				,	{ img: path+'sTtextOne.png', x:106, y:206, clipSprite:false, name:'sTtextOne' }
				,	{ img: path+'sTtextTwo.png', x:106, y:539, clipSprite:false, name:'sTtextTwo' }
				,	{ img: path+'sTtextThree.png', x:106, y:1056, clipSprite:false, name:'sTtextThree' }
		
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
			addChild(images['sTtextOne']);
			addChild(images['sTtextTwo']);
			addChild(images['sTtextThree']);
	
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append( TweenMax.to(images['sTwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['sTgreenSwoosh'].clipRect, .8, { width:images['sTgreenSwoosh'].originalWidth, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['sTtextOne'], .4, {alpha:1, ease:Sine.easeOut}), -0.4);
			timeline.append( TweenMax.to(images['sTtextTwo'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append( TweenMax.to(images['sTtextThree'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			

			
			reset();
			notifyReady();
		}
		
		private function onTransitionComplete():void
		{
			transitioning = OPEN;
			notifyScreenOpened();
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
			super.reset();
			
			timeline.gotoAndStop(0);
			images['sTwhiteBG'].x = -1080;
			images['sTgreenSwoosh'].clipRect.width = 0;
			images['sTtextOne'].alpha = 0;
			images['sTtextTwo'].alpha = 0;
			images['sTtextThree'].alpha = 0;
		}
	}
}
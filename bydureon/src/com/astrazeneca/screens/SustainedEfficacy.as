package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class SustainedEfficacy extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		public function SustainedEfficacy()
		{
			super();
			var baseDir:String = "sustainedEfficacy/";
			
			imageManifest = [
					{ img: baseDir+'whiteBG.png', x:0, y:96, clipSprite:false, name:'sEwhiteBG' }
				,	{ img: baseDir+'swish1.png', x:0, y:615, clipSprite:true, name:'sEswish1' }
				,	{ img: baseDir+'swish2.png', x:0, y:1190, clipSprite:true, name:'sEswish2' }
				,	{ img: baseDir+'arrow1.png', x:638, y:987, clipSprite:false, name:'sEarrow1' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
						
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['sEwhiteBG']);
			addChild(images['sEswish1']);
			addChild(images['sEswish2']);
			addChild(images['sEarrow1']); 
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sEwhiteBG'], .5, {x:10, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sEswish1'].clipRect, 1, {width:images['sEswish1'].originalWidth, ease:Sine.easeInOut}),-.2);
			timeline.append(TweenMax.to(images['sEswish2'].clipRect, 1, {width:images['sEswish2'].originalWidth, ease:Sine.easeOut}), -0.8);
			timeline.append(TweenMax.to(images['sEarrow1'], 1, {x: 638, ease:Sine.easeOut}), -0.8);
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
			images['sEwhiteBG'].x = -1080;
			images['sEswish1'].clipRect.width = 0;
			images['sEswish2'].clipRect.width = 0;
			images['sEarrow1'].x = 300;
		}
	}
}
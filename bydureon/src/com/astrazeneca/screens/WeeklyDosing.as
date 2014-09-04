package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class WeeklyDosing extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		
		public function WeeklyDosing()
		{
			super();
			
			var path:String = "weeklyDosing/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:-1080, y:96, clipSprite:false, name:'wDwhiteBG' }
				,	{ img: path+'ericsBox.png', x:46, y:811, clipSprite:false, name:'wDericsBox' }
				,	{ img: path+'orangeSwish.png', x:0, y:420, clipSprite:true, name:'wDorangeSwish' }
				,	{ img: path+'firstGrey.png', x:834, y:1050, clipSprite:true, name:'wDfirstGrey' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['wDwhiteBG']);
			addChild(images['wDericsBox']);
			addChild(images['wDorangeSwish'])
			addChild(images['wDfirstGrey']);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );	
			timeline.append( TweenMax.to(images['wDwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['wDorangeSwish'].clipRect, 1, { width:images['wDorangeSwish'].originalWidth, ease:Sine.easeInOut }), -.2);
			timeline.append( TweenMax.to(images['wDericsBox'], .5, { alpha:1, ease:Sine.easeOut }) );
			
		// 	timeline.insert(TweenMax.to(quad, 1, {alpha:1}));
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
			images['wDorangeSwish'].clipRect.width = 0;
			images['wDwhiteBG'].x = -1080;
			images['wDericsBox'].alpha = 0;
		}
	}
}
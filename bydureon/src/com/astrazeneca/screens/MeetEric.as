package com.astrazeneca.screens
{
	import com.astrazeneca.ClipSprite;
	import com.astrazeneca.ScreenBase;
	import com.astrazeneca.starling.StarlingCounter;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Sine;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class MeetEric extends ScreenBase
	{		
		private var timeline:TimelineMax;
		private var greenTextBar:ClipSprite;

		private var counter:StarlingCounter;
		
		
		
		public function MeetEric()
		{
			super();
			
			imageManifest = [
					{ img: 'meetEric/swish1.png', x:0, y:0, clipSprite:true, name:'swish1' }
				,	{ img: 'meetEric/swish2.png', x:0, y:201, clipSprite:true, name:'swish2' }
				,	{ img: 'meetEric/swish3.png', x:43, y:1525, clipSprite:true, name:'swish3' }
				,	{ img: 'meetEric/bigEric.png', x:43, y:475, clipSprite:false, name:'eric' }
				,	{ img: 'meetEric/whiteBG.png', x:-1080, y:49, clipSprite:false, name:'whiteBG' }
				,	{ img: 'meetEric/textLayer.png', x:0, y:0, clipSprite:false, name:'textLayer' }
				
			];
			
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['whiteBG']);
			addChild(images['swish2']);
			addChild(images['swish1']);			
			addChild(images['eric']);
			addChild(images['swish3']);
			addChild(images['textLayer']);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );
			timeline.append( TweenMax.to(images['whiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['swish1'].clipRect, 1, { width:images['swish1'].originalWidth, ease:Sine.easeInOut }), -.2);
			timeline.append( TweenMax.to(images['swish2'].clipRect, 1, { width:images['swish2'].originalWidth, ease:Sine.easeOut }), -.8 );
			timeline.append( TweenMax.to(images['eric'], .3, { alpha:1, ease:Sine.easeIn }), -0.8 );
			timeline.append( TweenMax.to(images['swish3'].clipRect, .4, { width:images['swish3'].originalWidth, ease:Sine.easeOut }), -0.4 );
			timeline.append( TweenMax.to(images['textLayer'], .4, { alpha:1, ease:Sine.easeOut }), 0 );
			
			images['textLayer'].touchable = false;
			
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
			//counter.setTo(0);
			TweenMax.to(this, .2, {alpha:0, ease:Sine.easeIn});
			notifyScreenClosed();
		}
		
		override public function show():void
		{
			super.show();
			
			transitioning = OPENING;
			timeline.timeScale(.7);
			timeline.play();
			
			//counter.countTo(20, 2);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			//counter.countTo(0, 0.2);
		}
		
		override public function reset():void
		{
			images['eric'].alpha = 0;
			images['textLayer'].alpha = 0;
			images['whiteBG'].x = -1080;
			images['swish1'].clipRect.width = images['swish2'].clipRect.width = 0;
		}
		
	}
}
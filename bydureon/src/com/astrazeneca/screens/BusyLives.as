package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
		
	public class BusyLives extends ScreenBase
	{
		private var timeline:TimelineMax;
		
		public function BusyLives()
		{
			super();
			
			var path:String = "busyLives/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:10, y:96, clipSprite:false, name:'bLwhiteBG' }
				,	{ img: path+'greenSwoosh.png', x:88, y:0, clipSprite:true, name:'bLgreenSwoosh' }
				,	{ img: path+'topOrangeSwoosh.png', x:159, y:0, clipSprite:true, name:'bLtopOrangeSwoosh' }
				,	{ img: path+'orangeSwoosh.png', x:56, y:0, clipSprite:true, name:'bLOrangeSwoosh' }
				,	{ img: path+'whiteSwoosh.png', x:120, y:0, clipSprite:true, name:'bLwhiteSwoosh' }
				,	{ img: path+'eric.png', x:460, y:158, clipSprite:false, name:'bLeric' }
				,	{ img: path+'bStext1.png', x:204, y:207, clipSprite:false, name:'bStext1' }
				,	{ img: path+'bStext2.png', x:95, y:703, clipSprite:false, name:'bStext2' }
			
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);			
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['bLwhiteBG']);
			addChild(images['bLOrangeSwoosh']);
			addChild(images['bLwhiteSwoosh']);
			addChild(images['bLgreenSwoosh']);
			addChild(images['bLtopOrangeSwoosh']);
			addChild(images['bLeric']);
			addChild(images['bStext1']);
			addChild(images['bStext2']);
		
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append( TweenMax.to(images['bLwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['bLtopOrangeSwoosh'].clipRect, .8, { width:images['bLtopOrangeSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.1 );
			timeline.append( TweenMax.to(images['bLwhiteSwoosh'].clipRect, .8, { width:images['bLwhiteSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.6 );
			timeline.append( TweenMax.to(images['bLgreenSwoosh'].clipRect, .8, { width:images['bLgreenSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.6);
			timeline.append( TweenMax.to(images['bLOrangeSwoosh'].clipRect, .8, { width:images['bLOrangeSwoosh'].originalWidth, ease:Sine.easeInOut }), -0.6 );
			timeline.append( TweenMax.to(images['bLeric'], .6, { alpha:1, ease:Sine.easeOut }), -0.2 );
			timeline.append( TweenMax.to(images['bStext1'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			timeline.append( TweenMax.to(images['bStext2'], .4, {alpha:1, ease:Sine.easeOut}), 0);
			
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
			images['bLwhiteBG'].x = -1080;
			images['bLgreenSwoosh'].clipRect.width = 0;
			images['bLwhiteSwoosh'].clipRect.width = 0;
			images['bLtopOrangeSwoosh'].clipRect.width = 0;
			images['bLOrangeSwoosh'].clipRect.width = 0;
			images['bLeric'].alpha = 0;
			images['bStext1'].alpha = 0;
			images['bStext2'].alpha = 0;
	
		}
	}
}
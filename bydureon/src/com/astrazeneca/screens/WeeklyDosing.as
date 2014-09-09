package com.astrazeneca.screens
{
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	
	import starling.display.Quad;
	
	public class WeeklyDosing extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;

		private var greyPositionsY:Array;
		private var greyPositionsX:Array;
		
		public function WeeklyDosing()
		{
			super();
			
			var path:String = "weeklyDosing/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:-1080, y:96, clipSprite:false, name:'wDwhiteBG' }
				,	{ img: path+'ericsBox.png', x:46, y:811, clipSprite:false, name:'wDericsBox' }
				,	{ img: path+'orangeSwish.png', x:0, y:420, clipSprite:true, name:'wDorangeSwish' }
				,	{ img: path+'injection.png', x:61, y:541, clipSprite:false, name:'wDinjection' }
				,	{ img: path+'greenCircle.png', x:490, y:732, clipSprite:false, name:'wDgreenCircle' }
				,	{ img: path+'wDtextLayer.png', x:0, y:0, clipSprite:false, name:'wDtextLayer' }
			];
			
			greyPositionsX = [588,588,588,590,591,592,592];
			greyPositionsY = [715,758,801,844,888,931,975];
			for(var i:int = 0; i < 7; ++i) imageManifest.push({ img: path+'grey'+i+'.png', x:greyPositionsX[i], y:greyPositionsY[i], clipSprite:true, name:'wDgrey'+i });
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
			
			
			var i:int;
			for(i=0; i < 7; ++i) addChild(images['wDgrey'+i]);
			
			addChild(images['wDorangeSwish']);
			addChild(images['wDinjection']);
			
			
			images['wDgreenCircle'].pivotX = images['wDgreenCircle'].width >> 1;
			images['wDgreenCircle'].pivotY = images['wDgreenCircle'].height >> 1;
			images['wDgreenCircle'].x += images['wDgreenCircle'].width >> 1;
			images['wDgreenCircle'].y += images['wDgreenCircle'].height >> 1;
			addChild(images['wDgreenCircle']);
			
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );	
			timeline.append( TweenMax.to(images['wDwhiteBG'], .5, { x:10, ease:Sine.easeOut }) );
			timeline.append( TweenMax.to(images['wDorangeSwish'].clipRect, 1, { width:images['wDorangeSwish'].originalWidth, ease:Sine.easeInOut }), -.2);
			
			for(i = 0; i < 7; ++i) timeline.append( TweenMax.to(images['wDgrey'+i].clipRect, .6, { width:images['wDgrey'+i].originalWidth, ease:Sine.easeInOut }), i > 0 ? -.5 : -.19);
			
			timeline.append( TweenMax.to(images['wDericsBox'], .5, { alpha:1, ease:Sine.easeOut }), -0.3);
			timeline.append( TweenMax.to(images['wDgreenCircle'], .7, { alpha:1, scaleX:1, scaleY:1, ease:Elastic.easeOut }), -.3);
			timeline.append( TweenMax.to(images['wDinjection'], 1, { alpha:1, ease:Sine.easeInOut }), -.8);
			timeline.append(TweenMax.to(images['wDtextLayer'], .4, {alpha:1, ease:Sine.easeOut}), -0.8);
			
			images['wDtextLayer'].touchable = false;
			
			addChild(images['wDtextLayer']);
			
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
			
			images['wDorangeSwish'].clipRect.width = 0;
			images['wDwhiteBG'].x = -1080;
			images['wDericsBox'].alpha = images['wDinjection'].alpha = 0;
			images['wDgreenCircle'].scaleX = images['wDgreenCircle'].scaleY = 0.8;
			images['wDgreenCircle'].alpha = 0;
			images['wDtextLayer'].alpha = 0;
			
			for(var i:int = 0; i < 7; ++i) images['wDgrey'+i].clipRect.width = 0;
		}
	}
}
package com.astrazeneca.screens
{
	import com.astrazeneca.PopUp;
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.wehaverhythm.starling.display.StarlingSimpleImageButton;
	
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SuperiorBasal extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		private var viewStudyButton:Sprite;
		private var popup:PopUp;
		
		public function SuperiorBasal()
		{
			super();
			var path:String = "superiorBasal/";
			
			imageManifest = [
				{ img: path+'whiteBG.png', x:13, y:96, clipSprite:false, name:'sBwhiteBG' }
				,	{ img: path+'swish1.png', x:48, y:0, clipSprite:true, name:'sBswish1' }
				,	{ img: path+'viewStudyTag.png', x:0, y:0, clipSprite:false, name:'sBviewStudyTag' }
				,	{ img: path+'popUp.png', x:0, y:0, clipSprite:false, name:'sBpopUp' }
				,	{ img: path+'sBtextLayer.png', x:0, y:0, clipSprite:false, name:'sBtextLayer' }
			];
		}
		
		override public function init(id:String):void
		{
			super.init(id);
			transitioning = CLOSED;
		}
		
		override protected function imagesReady():void
		{
			addChild(images['sBwhiteBG']);
			addChild(images['sBswish1']);
			addChild(images['sBtextLayer']);
			
			initViewStudyButton();
			
			
			popup = new PopUp(images['sBpopUp'], 0, 238, new Rectangle(859,35,67,64));
			popup.addEventListener("HIDING", onShowViewStudyButton);
			addChild(popup);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sBwhiteBG'], .5, {x:12, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sBswish1'].clipRect, 1, {width:images['sBswish1'].originalWidth, ease:Sine.easeInOut}),-.1);
			timeline.append(TweenMax.to(images['sBtextLayer'], .4, {alpha:1, ease:Sine.easeOut}), -0.8);
			
			images['sBtextLayer'].touchable = false;
			
			TweenMax.to(viewStudyButton, .3, {scaleX:.95, scaleY:.95, ease:com.greensock.easing.Quad.easeOut, repeat:-1, yoyo:true});
			
			reset();
			notifyReady();
		}
		
		private function onShowViewStudyButton(e:Event = null):void
		{
			TweenMax.to(viewStudyButton, .3, {x:1080, ease:Sine.easeOut});
			TweenMax.killDelayedCallsTo(onShowViewStudyButton);
		}
		
		private function initViewStudyButton():void
		{
			viewStudyButton = new StarlingSimpleImageButton();
			viewStudyButton.addChild(images['sBviewStudyTag']);
			addChild(viewStudyButton);
			viewStudyButton.pivotX = viewStudyButton.width;
			viewStudyButton.pivotY = viewStudyButton.height >> 1;
			viewStudyButton.addEventListener("TOUCHED", onViewStudyClicked);
			viewStudyButton.y = 1217 + (viewStudyButton.height >> 1);
			viewStudyButton.x = viewStudyButton.width;
		}
		
		private function onViewStudyClicked(e:Event):void
		{
			popup.show();
			hideViewStudyButton();
		}
		
		private function hideViewStudyButton():void
		{
			TweenMax.to(viewStudyButton, .3, {x:1100+viewStudyButton.width, ease:Sine.easeOut});
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
			
			TweenMax.delayedCall(1.8, onShowViewStudyButton);
		}
		
		override public function hide():void
		{
			transitioning = CLOSING;
			timeline.timeScale(4);
			timeline.reverse();
			
			popup.hide();
			hideViewStudyButton();
		}
		
		override public function reset():void
		{
			images['sBwhiteBG'].x = -1080;
			images['sBswish1'].clipRect.width = 0;
			images['sBtextLayer'].alpha = 0;
			
			viewStudyButton.x = 1100+viewStudyButton.width;
			TweenMax.killTweensOf(viewStudyButton);
			
			popup.reset();
		}
	}
}

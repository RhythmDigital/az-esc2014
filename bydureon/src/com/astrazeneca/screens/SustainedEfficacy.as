package com.astrazeneca.screens
{
	import com.astrazeneca.PopUp;
	import com.astrazeneca.ScreenBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.wehaverhythm.starling.display.StarlingSimpleImageButton;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SustainedEfficacy extends ScreenBase
	{
		private var quad:Quad;
		private var timeline:TimelineMax;
		private var viewStudyButton:Sprite;
		private var popup:PopUp;

		public function SustainedEfficacy()
		{
			super();
			
			var path:String = "sustainedEfficacy/";
			
			imageManifest = [
					{ img: path+'whiteBG.png', x:0, y:96, clipSprite:false, name:'sEwhiteBG' }
				,	{ img: path+'swish1.png', x:0, y:615, clipSprite:true, name:'sEswish1' }
				,	{ img: path+'swish2.png', x:0, y:1190, clipSprite:true, name:'sEswish2' }
				,	{ img: path+'swish3.png', x:0, y:904, clipSprite:true, name:'sEswish3' }
				,	{ img: path+'viewStudyTag.png', x:0, y:0, clipSprite:false, name:'sEviewStudyTag' }
				,	{ img: path+'popUpBg.png', x:0, y:0, clipSprite:false, name:'sEpopUp' }
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
			addChild(images['sEswish3']);
			addChild(images['sEswish1']);
			addChild(images['sEswish2']);
			
			initViewStudyButton();
			

			popup = new PopUp(images['sEpopUp'], 0, 238, new Rectangle(859,35,67,64));
			popup.addEventListener("HIDING", onShowViewStudyButton);
			addChild(popup);
			
			timeline = new TimelineMax( {paused: true, onComplete:onTransitionComplete, onReverseComplete:onReverseTransitionComplete} );			
			timeline.append(TweenMax.to(images['sEwhiteBG'], .5, {x:10, ease:Sine.easeOut}));
			timeline.append(TweenMax.to(images['sEswish1'].clipRect, 1, {width:images['sEswish1'].originalWidth, ease:Sine.easeInOut}),-.2);
			timeline.append(TweenMax.to(images['sEswish3'].clipRect, 1, {width:images['sEswish3'].originalWidth, ease:Sine.easeOut}), -0.8);
			timeline.append(TweenMax.to(images['sEswish2'].clipRect, 1, {width:images['sEswish2'].originalWidth, ease:Sine.easeOut}), -0.8);
			//timeline.append(TweenMax.to(viewStudyButton, .3, {x: 1080, ease:Sine.easeOut}));
			
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
			viewStudyButton.addChild(images['sEviewStudyTag']);
			addChild(viewStudyButton);
			viewStudyButton.pivotX = viewStudyButton.width;
			viewStudyButton.pivotY = viewStudyButton.height >> 1;
			viewStudyButton.addEventListener("TOUCHED", onViewStudyClicked);
			viewStudyButton.y = 970 + (viewStudyButton.height >> 1);
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
			images['sEwhiteBG'].x = -1080;
			images['sEswish1'].clipRect.width = 0;
			images['sEswish2'].clipRect.width = 0;
			images['sEswish3'].clipRect.width = 0;
			viewStudyButton.x = 1100+viewStudyButton.width;
			TweenMax.killTweensOf(viewStudyButton);
			
			popup.reset();
		}
	}
}
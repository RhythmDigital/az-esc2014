package com.astrazeneca.video
{
	import com.greensock.TweenMax;
	import com.wehaverhythm.gui.CheckBox;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.NetStream;
	import flash.utils.Timer;
	

	public class StageVideoControls extends VideoControls implements IDestroyable 
	{
		private var ns:NetStream;
		
		private var thumbRange:Object;
		private var duration:Number;
		private var draggingThumb:Boolean;
		
		private var stage:Stage;
		private var scale:Number;
		private var rect:Rectangle;
		
		public var belowVideo:Boolean = false;
		private var scrubTimer:Timer;

		private var seekTo:Number;
		
		
		public function StageVideoControls()
		{
			super();
			visible = false;
		}
		
		public function init(rect:Rectangle, fillScreen:Boolean, ns:NetStream, duration:Number, stage:Stage, iPad:Boolean=false):void
		{
			this.ns = ns;
			this.duration = duration;
			this.stage = stage;
			this.rect = rect;
			
			scale = 1;
			if (iPad && stage.stageWidth > 1024) scale = 2;
			stage.quality = StageQuality.BEST;
			
			bg.alpha = .6;			
			setWidth(fillScreen ? stage.stageWidth : rect.width);
			
			if (fillScreen)
			{
				x = 0;
				y = stage.stageHeight - 38*scale;
			}
			else {
				x = rect.x;
				y = rect.y + rect.height;
				if (!belowVideo) y -= 38*scale;
			}
			
			draggingThumb = false;
			thumb.x = thumbRange.left;
			thumb.mouseChildren = false;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownThumb);
			
			playPause.addEventListener(CheckBox.CLICKED, onPlayPauseClicked);						
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			onNetStatus(null);
			
			visible = true;
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onMouseDownThumb(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			draggingThumb = true;
			playPause.state = true;
			
			if (scrubTimer == null) 
			{
				scrubTimer = new Timer(100);
				scrubTimer.addEventListener(TimerEvent.TIMER, onTimerTick);
			}
			
			scrubTimer.start();
		}
		
		protected function onTimerTick(event:TimerEvent):void
		{
			seekToThumb();
		}
		
		private function seekToThumb():void
		{			
			seekTo = (thumb.x - thumbRange.left) / (thumbRange.width / duration);
			seekTo = Math.max(seekTo, 10);
			// trace('seeking to thumb:', seekTo);
			
			ns.seek(seekTo);
		}
		
		protected function onMouseUpStage(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			seekToThumb();
		
			scrubTimer.stop();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			draggingThumb = false;
			playPause.state = false;
		}
		
		private function onPlayPauseClicked(event:Event):void
		{
			playPause.state ? ns.pause() : ns.resume();
		}
		
		private function onEnterFrame(event:Event):void
		{		
		 	if (draggingThumb) 
			{
				thumb.x = Math.max(thumbRange.left, Math.min(mouseX, thumbRange.left + thumbRange.width));
			}
			else thumb.x = thumbRange.left + (thumbRange.width / duration) * ns.time;
			
			barPlayed.width = thumb.x - barPlayed.x;
		}
		
		public function setWidth(w:Number):void
		{	
			playPause.scaleX = playPause.scaleY = thumb.scaleX = thumb.scaleY
				= barPlayed.scaleX = barPlayed.scaleY = barBG.scaleX = barBG.scaleY = scale;
			
			if (scale == 2)
			{
				playPause.x = 50;
				barBG.y = barPlayed.y = 28;
				playPause.y = thumb.y = 36;
			}
			
			bg.height = 38.5*scale;
			bg.width = w;
			barBG.x = barPlayed.x = playPause.x + playPause.width;
			
			barBG.width = w - barBG.x - 40;
			barPlayed.width = 0;
			
			thumbRange = { left:barBG.x + 7*scale, width:barBG.width - 14*scale };
			
			// trace('thumbRange: { left:', thumbRange.left + ',', 'width:', thumbRange.width, '}');
		}		
		
		public function destroy():void
		{				
			ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			playPause.removeEventListener(CheckBox.CLICKED, onPlayPauseClicked);	
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			
			stage.quality = StageQuality.LOW;
			stage = null;
			ns = null;
			thumbRange = null;
			
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownThumb);
			thumb = null;
		}
	}
}